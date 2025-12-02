const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

async function managerCanAccess(managerId, targetPersonId) {
  if (!managerId || !targetPersonId) return false;
  const result = await db.query(
    'SELECT 1 FROM person WHERE person_id = $1 AND manager_person_id = $2',
    [targetPersonId, managerId]
  );
  return result.rowCount > 0;
}

// Get skills for current user
router.get('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;

    const result = await db.query(
            `SELECT ps.person_id,
              ps.skill_id,
              ps.status,
              ps.experience_years,
              ps.usage_frequency,
              ps.proficiency_level,
              ps.notes,
              ps.requested_at,
              s.skill_name,
              s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1
       ORDER BY s.skill_name`,
      [userId]
    );

    const skills = result.rows.map(row => ({
      id: row.skill_id,
      name: row.skill_name,
      type: row.skill_type,
      status: row.status,
      person_id: row.person_id,
      experience_years: row.experience_years,
      usage_frequency: row.usage_frequency,
      proficiency_level: row.proficiency_level,
      notes: row.notes,
      requested_at: row.requested_at,
    }));

    res.json(skills);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get skills for a specific user (admin/manager only)
router.get('/user/:userId', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const { userId } = req.params;

    const result = await db.query(
            `SELECT ps.person_id,
              ps.skill_id,
              ps.status,
              ps.experience_years,
              ps.usage_frequency,
              ps.proficiency_level,
              ps.notes,
              ps.requested_at,
              s.skill_name,
              s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1
       ORDER BY s.skill_name`,
      [userId]
    );

    const skills = result.rows.map(row => ({
      id: row.skill_id,
      name: row.skill_name,
      type: row.skill_type,
      status: row.status,
      person_id: row.person_id,
      experience_years: row.experience_years,
      usage_frequency: row.usage_frequency,
      proficiency_level: row.proficiency_level,
      notes: row.notes,
      requested_at: row.requested_at,
    }));

    res.json(skills);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add a skill to current user's profile
router.post('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    const {
      skill_id,
      experience_years = 0,
      usage_frequency = 'Occasionally',
      proficiency_level = 'Intermediate',
      notes = '',
    } = req.body;
    const requestedAtValue = new Date();

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    // Check if skill exists
    const skillCheck = await db.query('SELECT skill_id FROM skill WHERE skill_id = $1', [skill_id]);
    if (skillCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    const existingSkill = await db.query(
      'SELECT 1 FROM person_skill WHERE person_id = $1 AND skill_id = $2',
      [userId, skill_id]
    );

    if (existingSkill.rowCount > 0) {
      return res.status(409).json({ error: 'Skill already exists in your inventory. Use edit to update it.' });
    }

    // Insert person_skill request
    const result = await db.query(
      `INSERT INTO person_skill (person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at)
       VALUES ($1, $2, 'Pending', $3, $4, $5, $6, $7)
       RETURNING person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at`,
      [userId, skill_id, experience_years, usage_frequency, proficiency_level, notes, requestedAtValue]
    );

    res.status(201).json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
      experience_years: result.rows[0].experience_years,
      usage_frequency: result.rows[0].usage_frequency,
      proficiency_level: result.rows[0].proficiency_level,
      notes: result.rows[0].notes,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Add a skill to a specific user (admin only)
router.post('/user/:userId', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { userId } = req.params;
    const {
      skill_id,
      status = 'Pending',
      experience_years = 0,
      usage_frequency = 'Occasionally',
      proficiency_level = 'Intermediate',
      notes = '',
      requested_at,
    } = req.body;

    const requestedAtValue = requested_at ? new Date(requested_at) : new Date();

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    // Check if skill exists
    const skillCheck = await db.query('SELECT skill_id FROM skill WHERE skill_id = $1', [skill_id]);
    if (skillCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    // Check if user exists
    const userCheck = await db.query('SELECT person_id FROM person WHERE person_id = $1', [userId]);
    if (userCheck.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const result = await db.query(
      `INSERT INTO person_skill (person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       ON CONFLICT (person_id, skill_id) DO UPDATE SET
         status = EXCLUDED.status,
         experience_years = EXCLUDED.experience_years,
         usage_frequency = EXCLUDED.usage_frequency,
         proficiency_level = EXCLUDED.proficiency_level,
         notes = EXCLUDED.notes,
         requested_at = CASE
           WHEN EXCLUDED.status = 'Pending' THEN EXCLUDED.requested_at
           ELSE person_skill.requested_at
         END
       RETURNING person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at`,
      [userId, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requestedAtValue]
    );

    res.status(201).json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
      experience_years: result.rows[0].experience_years,
      usage_frequency: result.rows[0].usage_frequency,
      proficiency_level: result.rows[0].proficiency_level,
      notes: result.rows[0].notes,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update skill status for current user
router.put('/me/:skillId', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { skillId } = req.params;
    const {
      experience_years,
      usage_frequency,
      proficiency_level,
      notes,
    } = req.body;
    const hasUpdates = [experience_years, usage_frequency, proficiency_level, notes].some((value) => value !== undefined);

    if (!hasUpdates) {
      return res.status(400).json({ error: 'Provide at least one field to update.' });
    }

    const result = await db.query(
      `UPDATE person_skill
           SET experience_years = COALESCE($3, experience_years),
           usage_frequency = COALESCE($4, usage_frequency),
           proficiency_level = COALESCE($5, proficiency_level),
           notes = COALESCE($6, notes)
       WHERE person_id = $1 AND skill_id = $2
         RETURNING person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at`,
        [userId, skillId, experience_years, usage_frequency, proficiency_level, notes]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
      experience_years: result.rows[0].experience_years,
      usage_frequency: result.rows[0].usage_frequency,
      proficiency_level: result.rows[0].proficiency_level,
      notes: result.rows[0].notes,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update skill status for a specific user (admin only)
router.put('/user/:userId/:skillId', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const { userId, skillId } = req.params;
    const {
      status,
      experience_years,
      usage_frequency,
      proficiency_level,
      notes,
      requested_at,
    } = req.body;

    const allowedStatuses = new Set(['Approved', 'Canceled', 'Pending']);
    if (!allowedStatuses.has(status)) {
      return res.status(400).json({ error: 'Invalid status value' });
    }

    if (req.user.role === 'manager') {
      const permitted = await managerCanAccess(req.user.person_id, userId);
      if (!permitted) {
        return res.status(403).json({ error: 'Managers may only update their direct reports.' });
      }
    }

    const requestedAtValue = status === 'Pending'
      ? (requested_at ? new Date(requested_at) : new Date())
      : null;

    if (!status) {
      return res.status(400).json({ error: 'status is required' });
    }

    const result = await db.query(
      `UPDATE person_skill
         SET status = $1,
           experience_years = COALESCE($4, experience_years),
           usage_frequency = COALESCE($5, usage_frequency),
           proficiency_level = COALESCE($6, proficiency_level),
           notes = COALESCE($7, notes),
           requested_at = CASE WHEN $1 = 'Pending' THEN COALESCE($8, requested_at) ELSE requested_at END
       WHERE person_id = $2 AND skill_id = $3
         RETURNING person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at`,
        [status, userId, skillId, experience_years, usage_frequency, proficiency_level, notes, requestedAtValue]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
      experience_years: result.rows[0].experience_years,
      usage_frequency: result.rows[0].usage_frequency,
      proficiency_level: result.rows[0].proficiency_level,
      notes: result.rows[0].notes,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Remove a skill from current user
router.delete('/me/:skillId', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { skillId } = req.params;

    const result = await db.query(
      'DELETE FROM person_skill WHERE person_id = $1 AND skill_id = $2 RETURNING person_id, skill_id',
      [userId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({ message: 'Skill removed successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Remove a skill from a specific user (admin only)
router.delete('/user/:userId/:skillId', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { userId, skillId } = req.params;

    const result = await db.query(
      'DELETE FROM person_skill WHERE person_id = $1 AND skill_id = $2 RETURNING person_id, skill_id',
      [userId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({ message: 'Skill removed successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
