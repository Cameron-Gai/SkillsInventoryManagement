const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

const VALID_SKILL_TYPES = new Set(['Knowledge', 'Experience', 'Technology', 'Other']);

async function ensureCatalogRequestsTable() {
  // Create table if not exists. Keeps current repo self-contained.
  await db.query(`
    CREATE TABLE IF NOT EXISTS skill_request (
      request_id SERIAL PRIMARY KEY,
      requested_by INTEGER NOT NULL REFERENCES person(person_id),
      skill_name VARCHAR(255) NOT NULL,
      skill_type public.skill_type_enum NOT NULL,
      justification TEXT,
      status public.person_skill_status_enum DEFAULT 'Requested' NOT NULL,
      created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
      resolved_at TIMESTAMP WITHOUT TIME ZONE,
      resolved_by INTEGER REFERENCES person(person_id),
      resolution_notes TEXT,
      created_skill_id INTEGER REFERENCES skill(skill_id)
    );
  `);
  // Unique pending request per name
  await db.query(`
    CREATE UNIQUE INDEX IF NOT EXISTS skill_request_unique_active
    ON skill_request (LOWER(skill_name))
    WHERE status IN ('Requested');
  `);
}

const serializeCatalogRequest = (row) => ({
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

// Create Catalog Request
router.post('/', authenticate, async (req, res) => {
  try {
    await ensureCatalogRequestsTable();
    const { skill_name, skill_type, justification = '' } = req.body;
    if (!skill_name || !skill_type) {
      return res.status(400).json({ error: 'skill_name and skill_type are required' });
    }
    if (!VALID_SKILL_TYPES.has(skill_type)) {
      return res.status(400).json({ error: 'Invalid skill_type' });
    }
    const trimmedName = String(skill_name).trim();
    if (!trimmedName) {
      return res.status(400).json({ error: 'skill_name cannot be empty' });
    }

    // Prevent duplicates vs catalog and pending
    const duplicateSkill = await db.query(
      'SELECT 1 FROM skill WHERE LOWER(skill_name) = LOWER($1)',
      [trimmedName]
    );
    if (duplicateSkill.rowCount > 0) {
      return res.status(409).json({ error: 'Skill already exists in the catalog.' });
    }
    const duplicateRequest = await db.query(
      `SELECT 1 FROM skill_request WHERE LOWER(skill_name) = LOWER($1) AND status = 'Requested'`,
      [trimmedName]
    );
    if (duplicateRequest.rowCount > 0) {
      return res.status(409).json({ error: 'A Catalog Request for this skill is already pending.' });
    }

    // Enforce max 1 pending catalog request per user
    const pendingCatalogRes = await db.query(
      `SELECT COUNT(*)::int AS cnt FROM skill_request WHERE requested_by = $1 AND status = 'Requested'`,
      [req.user.person_id]
    );
    if ((pendingCatalogRes.rows[0].cnt || 0) >= 1) {
      return res.status(429).json({ error: 'You already have an active catalog request.' });
    }

    const insert = await db.query(
      `INSERT INTO skill_request (requested_by, skill_name, skill_type, justification)
       VALUES ($1, $2, $3, $4)
       RETURNING request_id, skill_name, skill_type, justification, status, created_at`,
      [req.user.person_id, trimmedName, skill_type, justification.trim()]
    );

    const row = insert.rows[0];
    res.status(201).json({
      request_id: row.request_id,
      skill_name: row.skill_name,
      skill_type: row.skill_type,
      justification: row.justification || '',
      status: row.status,
      created_at: row.created_at,
    });
  } catch (err) {
    console.error('Create Catalog Request failed:', err);
    res.status(500).json({ error: err.message });
  }
});

// List all Catalog Requests (admin)
router.get('/', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureCatalogRequestsTable();
    const result = await db.query(
      `SELECT sr.*, req.person_name AS requested_by_name, res.person_name AS resolved_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       LEFT JOIN person res ON res.person_id = sr.resolved_by
       ORDER BY sr.created_at DESC`
    );
    res.json(result.rows.map(serializeCatalogRequest));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Approve/Reject Catalog Request (admin)
router.put('/:requestId', authenticate, authorizeRoles('admin'), async (req, res) => {
  const { requestId } = req.params;
  const { action, resolution_notes = '' } = req.body || {};
  const act = String(action || '').toLowerCase();
  if (!['approve', 'reject'].includes(act)) {
    return res.status(400).json({ error: 'action must be approve or reject' });
  }
  const client = await db.connect();
  try {
    await ensureCatalogRequestsTable();
    await client.query('BEGIN');
    const reqRes = await client.query(
      `SELECT sr.*, req.person_name AS requested_by_name
       FROM skill_request sr
       JOIN person req ON req.person_id = sr.requested_by
       WHERE sr.request_id = $1
       FOR UPDATE`,
      [requestId]
    );
    if (reqRes.rowCount === 0) {
      await client.query('ROLLBACK');
      return res.status(404).json({ error: 'Catalog Request not found' });
    }
    const request = reqRes.rows[0];
    if (request.status !== 'Requested') {
      await client.query('ROLLBACK');
      return res.status(409).json({ error: 'Request already processed' });
    }

    const now = new Date();
    let createdSkill = null;
    if (act === 'approve') {
      // Sync sequence to prevent duplicate primary key errors if data was imported
      await client.query(
        `SELECT setval('public.skill_skill_id_seq', COALESCE((SELECT MAX(skill_id) FROM public.skill), 0))`
      );
      const exists = await client.query(
        'SELECT skill_id FROM skill WHERE LOWER(skill_name) = LOWER($1)',
        [request.skill_name]
      );
      if (exists.rowCount > 0) {
        await client.query('ROLLBACK');
        return res.status(409).json({ error: 'A skill with that name already exists.' });
      }

      const skillInsert = await client.query(
        "INSERT INTO skill (skill_name, status, skill_type) VALUES ($1, 'Approved', $2) RETURNING skill_id, skill_name, skill_type",
        [request.skill_name, request.skill_type]
      );
      createdSkill = skillInsert.rows[0];

      await client.query(
        `INSERT INTO person_skill (person_id, skill_id, status)
         VALUES ($1, $2, 'Requested')
         ON CONFLICT (person_id, skill_id) DO NOTHING`,
        [request.requested_by, createdSkill.skill_id]
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
           SET status = 'Canceled', resolved_at = $2, resolved_by = $3, resolution_notes = $4
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
    res.json(serializeCatalogRequest(refreshed.rows[0]));
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Process Catalog Request failed:', err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// Edit pending Catalog Request (admin)
router.patch('/:requestId', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureCatalogRequestsTable();
    const { requestId } = req.params;
    const { skill_name, skill_type, justification } = req.body || {};
    if (!skill_name && !skill_type && justification === undefined) {
      return res.status(400).json({ error: 'Provide at least one field to update.' });
    }
    const reqRes = await db.query('SELECT * FROM skill_request WHERE request_id = $1', [requestId]);
    if (reqRes.rowCount === 0) return res.status(404).json({ error: 'Catalog Request not found' });
    const request = reqRes.rows[0];
    if (request.status !== 'Requested') return res.status(409).json({ error: 'Only pending requests can be edited' });

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
      const dupSkill = await db.query('SELECT 1 FROM skill WHERE LOWER(skill_name) = LOWER($1)', [updates.skill_name]);
      if (dupSkill.rowCount > 0) return res.status(409).json({ error: 'A skill with that name already exists.' });
      const dupReq = await db.query(
        `SELECT 1 FROM skill_request WHERE LOWER(skill_name) = LOWER($1) AND request_id <> $2 AND status = 'Requested'`,
        [updates.skill_name, requestId]
      );
      if (dupReq.rowCount > 0) return res.status(409).json({ error: 'Another active Catalog Request uses that name.' });
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
    res.json(serializeCatalogRequest(refreshed.rows[0]));
  } catch (err) {
    console.error('Edit Catalog Request failed:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
