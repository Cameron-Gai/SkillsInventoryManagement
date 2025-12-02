const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const VALID_SKILL_TYPES = new Set(['Knowledge', 'Experience', 'Technology', 'Other']);

const router = express.Router();

const serializeRequest = (row) => ({
  request_id: row.request_id,
  skill_name: row.skill_name,
  skill_type: row.skill_type,
  justification: row.justification || '',
  status: row.status,
  created_at: row.created_at,
  resolved_at: row.resolved_at,
  resolution_notes: row.resolution_notes || '',
  requested_by: row.requested_by,
  requested_by_name: row.requested_by_name,
  resolved_by: row.resolved_by,
  resolved_by_name: row.resolved_by_name,
  created_skill_id: row.created_skill_id,
});

async function ensureSkillSequence(client) {
  try {
    await client.query(`
      SELECT setval(
        'skill_skill_id_seq',
        GREATEST(
          (SELECT COALESCE(MAX(skill_id), 0) FROM skill),
          (SELECT COALESCE(last_value, 0) FROM skill_skill_id_seq)
        )
      )
    `);
  } catch (seqErr) {
    console.warn('Unable to align skill sequence:', seqErr.message);
  }
}

router.post('/', authenticate, async (req, res) => {
  try {
    const { skill_name, skill_type, justification = '' } = req.body;
    if (!skill_name || !skill_type) {
      return res.status(400).json({ error: 'skill_name and skill_type are required' });
    }

    if (!VALID_SKILL_TYPES.has(skill_type)) {
      return res.status(400).json({ error: 'Invalid skill_type' });
    }

    const trimmedName = skill_name.trim();
    if (!trimmedName) {
      return res.status(400).json({ error: 'skill_name cannot be empty' });
    }

    const duplicateSkill = await db.query(
      'SELECT 1 FROM skill WHERE LOWER(skill_name) = LOWER($1)',
      [trimmedName]
    );
    if (duplicateSkill.rowCount > 0) {
      return res.status(409).json({ error: 'Skill already exists in the catalog.' });
    }

    const duplicateRequest = await db.query(
      "SELECT 1 FROM skill_request WHERE LOWER(skill_name) = LOWER($1) AND status::text IN ('Requested', 'Pending')",
      [trimmedName]
    );
    if (duplicateRequest.rowCount > 0) {
      return res.status(409).json({ error: 'Skill has already been requested and is awaiting review.' });
    }

    const insertResult = await db.query(
      `INSERT INTO skill_request (requested_by, skill_name, skill_type, justification)
       VALUES ($1, $2, $3, $4)
       RETURNING request_id, skill_name, skill_type, justification, status, created_at`,
      [req.user.person_id, trimmedName, skill_type, justification.trim()]
    );

    const row = insertResult.rows[0];
    res.status(201).json({
      request_id: row.request_id,
      skill_name: row.skill_name,
      skill_type: row.skill_type,
      justification: row.justification || '',
      status: row.status,
      created_at: row.created_at,
    });
  } catch (err) {
    console.error('Skill request creation failed:', err);
    res.status(500).json({ error: err.message });
  }
});

router.get('/', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const result = await db.query(
      `SELECT sr.*, req.person_name AS requested_by_name, res.person_name AS resolved_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       LEFT JOIN person res ON res.person_id = sr.resolved_by
       ORDER BY sr.created_at DESC`
    );

    res.json(result.rows.map(serializeRequest));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.put('/:requestId', authenticate, authorizeRoles('admin'), async (req, res) => {
  const { requestId } = req.params;
  const { action, resolution_notes = '' } = req.body;

  if (!['approve', 'reject'].includes((action || '').toLowerCase())) {
    return res.status(400).json({ error: 'action must be approve or reject' });
  }

  const client = await db.connect();
  try {
    await client.query('BEGIN');
    const requestResult = await client.query(
      `SELECT sr.*, req.person_name AS requested_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       WHERE sr.request_id = $1
       FOR UPDATE`,
      [requestId]
    );

    if (requestResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return res.status(404).json({ error: 'Skill request not found' });
    }

    const request = requestResult.rows[0];
    if (!['Requested', 'Pending'].includes(request.status)) {
      await client.query('ROLLBACK');
      return res.status(409).json({ error: 'Request has already been processed' });
    }

    let createdSkill = null;
    const now = new Date();
    if (action === 'approve') {
      const existingSkill = await client.query(
        'SELECT skill_id FROM skill WHERE LOWER(skill_name) = LOWER($1)',
        [request.skill_name]
      );
      if (existingSkill.rowCount > 0) {
        await client.query('ROLLBACK');
        return res.status(409).json({ error: 'A skill with that name already exists.' });
      }

      await ensureSkillSequence(client);

      const skillInsert = await client.query(
        "INSERT INTO skill (skill_name, status, skill_type) VALUES ($1, 'Approved', $2) RETURNING skill_id, skill_name, skill_type",
        [request.skill_name, request.skill_type]
      );
      createdSkill = skillInsert.rows[0];

      await client.query(
        `INSERT INTO person_skill (person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at)
         VALUES ($1, $2, 'Pending', 0, 'Occasionally', 'Intermediate', $3, $4)
         ON CONFLICT (person_id, skill_id) DO NOTHING`,
        [request.requested_by, createdSkill.skill_id, 'Requested via new skill approval', now]
      );

      await client.query(
        `UPDATE skill_request
           SET status = 'Approved', resolved_at = $2, resolved_by = $3, resolution_notes = $4, created_skill_id = $5
         WHERE request_id = $1`,
        [requestId, now, req.user.person_id, resolution_notes || null, createdSkill.skill_id]
      );
    } else {
      await client.query(
        `UPDATE skill_request
           SET status = 'Rejected', resolved_at = $2, resolved_by = $3, resolution_notes = $4
         WHERE request_id = $1`,
        [requestId, now, req.user.person_id, resolution_notes || null]
      );
    }

    await client.query('COMMIT');

    const refreshed = await db.query(
      `SELECT sr.*, req.person_name AS requested_by_name, res.person_name AS resolved_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       LEFT JOIN person res ON res.person_id = sr.resolved_by
       WHERE sr.request_id = $1`,
      [requestId]
    );

    res.json(serializeRequest(refreshed.rows[0]));
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Failed to process skill request:', err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

router.patch('/:requestId', authenticate, authorizeRoles('admin'), async (req, res) => {
  const { requestId } = req.params;
  const { skill_name, skill_type, justification } = req.body || {};

  if (!skill_name && !skill_type && justification === undefined) {
    return res.status(400).json({ error: 'Provide at least one field to update.' });
  }

  try {
    const requestResult = await db.query(
      `SELECT sr.*
       FROM skill_request sr
       WHERE sr.request_id = $1`,
      [requestId]
    );

    if (requestResult.rowCount === 0) {
      return res.status(404).json({ error: 'Skill request not found' });
    }

    const request = requestResult.rows[0];
    if (!['Requested', 'Pending'].includes(request.status)) {
      return res.status(409).json({ error: 'Only pending requests can be edited' });
    }

    const updates = {
      skill_name: skill_name?.trim?.() ?? null,
      skill_type: skill_type ?? null,
      justification: justification ?? null,
    };

    if (updates.skill_name !== null && updates.skill_name.length === 0) {
      return res.status(400).json({ error: 'skill_name cannot be empty' });
    }

    if (updates.skill_type !== null && !VALID_SKILL_TYPES.has(updates.skill_type)) {
      return res.status(400).json({ error: 'Invalid skill_type' });
    }

    if (updates.skill_name) {
      const duplicateSkill = await db.query(
        'SELECT 1 FROM skill WHERE LOWER(skill_name) = LOWER($1)',
        [updates.skill_name]
      );
      if (duplicateSkill.rowCount > 0) {
        return res.status(409).json({ error: 'A skill with that name already exists.' });
      }

      const duplicateRequest = await db.query(
        `SELECT 1 FROM skill_request
         WHERE LOWER(skill_name) = LOWER($1)
           AND request_id <> $2
           AND status::text IN ('Requested', 'Pending')`,
        [updates.skill_name, requestId]
      );
      if (duplicateRequest.rowCount > 0) {
        return res.status(409).json({ error: 'Another active request already uses that name.' });
      }
    }

    await db.query(
      `UPDATE skill_request
         SET skill_name = COALESCE($2, skill_name),
             skill_type = COALESCE($3, skill_type),
             justification = COALESCE($4, justification)
       WHERE request_id = $1`,
      [requestId, updates.skill_name, updates.skill_type, updates.justification?.trim?.() ?? null]
    );

    const refreshed = await db.query(
      `SELECT sr.*, req.person_name AS requested_by_name, res.person_name AS resolved_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       LEFT JOIN person res ON res.person_id = sr.resolved_by
       WHERE sr.request_id = $1`,
      [requestId]
    );

    res.json(serializeRequest(refreshed.rows[0]));
  } catch (err) {
    console.error('Failed to edit skill request:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
