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
      `SELECT ps.person_id, ps.skill_id, ps.status, s.skill_name, s.skill_type
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
    const { skill_id, status = 'Requested' } = req.body;

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    // Check if skill exists
    const skillCheck = await db.query('SELECT skill_id FROM skill WHERE skill_id = $1', [skill_id]);
    if (skillCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    // Insert or update person_skill
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
