const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

// Get skills for current user
router.get('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;

    const result = await db.query(
      `SELECT ps.person_id, ps.skill_id, ps.status, ps.level, ps.years, ps.frequency, ps.notes,
              s.skill_name, s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1 AND ps.status <> 'Canceled'
       ORDER BY s.skill_name`,
      [userId]
    );

    const skills = result.rows.map(row => ({
      id: row.skill_id,
      name: row.skill_name,
      type: row.skill_type,
      status: row.status,
      person_id: row.person_id,
      level: row.level,
      years: row.years,
      frequency: row.frequency,
      notes: row.notes,
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
      `SELECT ps.person_id, ps.skill_id, ps.status, s.skill_name, s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1 ${req.user.role === 'admin' ? '' : "AND ps.status <> 'Canceled'"}
       ORDER BY s.skill_name`,
      [userId]
    );

    const skills = result.rows.map(row => ({
      id: row.skill_id,
      name: row.skill_name,
      type: row.skill_type,
      status: row.status,
      person_id: row.person_id,
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
    const { skill_id, level, years, frequency, notes } = req.body;

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    // Check if skill exists
    const skillCheck = await db.query(
      'SELECT skill_id, skill_name, skill_type FROM skill WHERE skill_id = $1',
      [skill_id]
    );

    if (skillCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    const skill = skillCheck.rows[0];

    // Determine if this is a new skill or an edit
    const existingRes = await db.query(
      'SELECT status, level FROM person_skill WHERE person_id = $1 AND skill_id = $2',
      [userId, skill_id]
    );

    const LEVEL_ORDER = { beginner: 1, intermediate: 2, advanced: 3, expert: 4 };

    let result;
    if (existingRes.rows.length === 0) {
      // Enforce max 3 pending skill requests for the current user
      const pendingCountRes = await db.query(
        `SELECT COUNT(*)::int AS cnt FROM person_skill WHERE person_id = $1 AND status = 'Requested'`,
        [userId]
      );
      if ((pendingCountRes.rows[0].cnt || 0) >= 3) {
        return res.status(429).json({ error: 'You have reached the limit of 3 pending skill requests.' });
      }
      // New skill: always create as Requested
      result = await db.query(
        `INSERT INTO person_skill (person_id, skill_id, status, level, years, frequency, notes, requested_at)
         VALUES ($1, $2, 'Requested', $3, $4, $5, $6, NOW())
         RETURNING person_id, skill_id, status, level, years, frequency, notes, requested_at`,
        [userId, skill_id, level, years, frequency, notes]
      );
    } else {
      // Existing skill: only pend if level increases
      const prevLevel = (existingRes.rows[0].level || '').toLowerCase();
      const nextLevel = (level || '').toLowerCase();
      const prevRank = LEVEL_ORDER[prevLevel] || 0;
      const nextRank = LEVEL_ORDER[nextLevel] || 0;
      const increased = nextRank > prevRank;

      // If proficiency increases, pend the change even if user already has 3 pending.
      // New skill requests are still limited to 3, but edits can temporarily overflow.

      result = await db.query(
        `UPDATE person_skill
         SET level = $1, years = $2, frequency = $3, notes = $4
         ${increased ? ", status = 'Requested', requested_at = NOW()" : ''}
         WHERE person_id = $5 AND skill_id = $6
         RETURNING person_id, skill_id, status, level, years, frequency, notes, requested_at`,
        [level, years, frequency, notes, userId, skill_id]
      );
    }

    res.status(201).json({
      id: skill.skill_id,
      name: skill.skill_name,
      type: skill.skill_type,
      status: result.rows[0].status,
      level: result.rows[0].level,
      years: result.rows[0].years,
      frequency: result.rows[0].frequency,
      notes: result.rows[0].notes,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    console.error('Error in POST /person-skills/me:', err);
    res.status(500).json({ error: err.message });
  }
});

// Add a skill to a specific user (admin only)
router.post('/user/:userId', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { userId } = req.params;
    const { skill_id, status = 'Requested' } = req.body;

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
      `INSERT INTO person_skill (person_id, skill_id, status)
       VALUES ($1, $2, $3)
       ON CONFLICT (person_id, skill_id) DO UPDATE SET status = EXCLUDED.status
       RETURNING person_id, skill_id, status`,
      [userId, skill_id, status]
    );

    res.status(201).json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
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
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ error: 'status is required' });
    }

    const setRequestedAt = status === 'Requested' ? ', requested_at = NOW()' : ''
    const result = await db.query(
      `UPDATE person_skill SET status = $1${setRequestedAt} WHERE person_id = $2 AND skill_id = $3 RETURNING person_id, skill_id, status, requested_at`,
      [status, userId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
      requested_at: result.rows[0].requested_at,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update skill status for a specific user (admin only)
router.put('/user/:userId/:skillId', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { userId, skillId } = req.params;
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({ error: 'status is required' });
    }

    const result = await db.query(
      'UPDATE person_skill SET status = $1 WHERE person_id = $2 AND skill_id = $3 RETURNING person_id, skill_id, status',
      [status, userId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update skill details for a specific user (admin or manager)
router.put('/user/:userId/:skillId/details', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const { userId, skillId } = req.params;
    const { level, years, frequency, notes } = req.body;

    const result = await db.query(
      `UPDATE person_skill
       SET level = $1, years = $2, frequency = $3, notes = $4
       WHERE person_id = $5 AND skill_id = $6
       RETURNING person_id, skill_id, status, level, years, frequency, notes`,
      [level, years, frequency, notes, userId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for user' });
    }

    res.json(result.rows[0]);
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

// Admin: add a skill to self as Approved (bypass approval)
router.post('/admin/me', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { skill_id, level, years, frequency, notes } = req.body;

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    const skillCheck = await db.query('SELECT skill_id, skill_name, skill_type FROM skill WHERE skill_id = $1', [skill_id]);
    if (skillCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }
    const skill = skillCheck.rows[0];

    const result = await db.query(
      `INSERT INTO person_skill (person_id, skill_id, status, level, years, frequency, notes)
       VALUES ($1, $2, 'Approved', $3, $4, $5, $6)
       ON CONFLICT (person_id, skill_id) DO UPDATE SET status = 'Approved', level = $3, years = $4, frequency = $5, notes = $6
       RETURNING status, level, years, frequency, notes`,
      [userId, skill_id, level, years, frequency, notes]
    );

    res.status(201).json({
      id: skill.skill_id,
      name: skill.skill_name,
      type: skill.skill_type,
      status: result.rows[0].status,
      level: result.rows[0].level,
      years: result.rows[0].years,
      frequency: result.rows[0].frequency,
      notes: result.rows[0].notes,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
