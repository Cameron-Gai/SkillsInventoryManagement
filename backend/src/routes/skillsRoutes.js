const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

// Get all skills (authenticated users)
router.get('/', authenticate, async (req, res) => {
  try {
    const result = await db.query(
      'SELECT skill_id, skill_name, status, skill_type FROM skill ORDER BY skill_name'
    );

    const skills = result.rows.map(skill => ({
      id: skill.skill_id,
      name: skill.skill_name,
      status: skill.status,
      type: skill.skill_type,
    }));

    res.json(skills);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// List skills a person does NOT yet have (available to add)
router.get('/available/:personId', authenticate, async (req, res) => {
  try {
    const { personId } = req.params;
    const result = await db.query(
      `SELECT s.skill_id, s.skill_name, s.skill_type
       FROM skill s
       WHERE NOT EXISTS (
         SELECT 1 FROM person_skill ps
         WHERE ps.person_id = $1 AND ps.skill_id = s.skill_id
       )
       ORDER BY s.skill_name ASC`,
      [personId]
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch available skills' });
  }
});

// Get a specific skill by ID (authenticated users)
router.get('/:id', authenticate, async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query(
      'SELECT skill_id, skill_name, status, skill_type FROM skill WHERE skill_id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    const skill = result.rows[0];
    res.json({
      id: skill.skill_id,
      name: skill.skill_name,
      status: skill.status,
      type: skill.skill_type,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new skill (admin only)
router.post('/', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { skill_name, skill_type } = req.body;

    if (!skill_name || !skill_type) {
      return res.status(400).json({ error: 'skill_name and skill_type are required' });
    }

    const result = await db.query(
      "INSERT INTO skill (skill_name, status, skill_type) VALUES ($1, 'Approved', $2) RETURNING skill_id, skill_name, status, skill_type",
      [skill_name, skill_type]
    );

    const skill = result.rows[0];
    res.status(201).json({
      id: skill.skill_id,
      name: skill.skill_name,
      status: skill.status,
      type: skill.skill_type,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update a skill (admin only)
router.put('/:id', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const { skill_name, skill_type, status } = req.body;

    const updates = [];
    const values = [];
    let paramCount = 1;

    if (skill_name !== undefined) {
      updates.push(`skill_name = $${paramCount}`);
      values.push(skill_name);
      paramCount++;
    }

    if (skill_type !== undefined) {
      updates.push(`skill_type = $${paramCount}`);
      values.push(skill_type);
      paramCount++;
    }

    if (status !== undefined) {
      updates.push(`status = $${paramCount}`);
      values.push(status);
      paramCount++;
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    values.push(id);
    const query = `UPDATE skill SET ${updates.join(', ')} WHERE skill_id = $${paramCount} RETURNING skill_id, skill_name, status, skill_type`;

    const result = await db.query(query, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    const skill = result.rows[0];
    res.json({
      id: skill.skill_id,
      name: skill.skill_name,
      status: skill.status,
      type: skill.skill_type,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete a skill (admin only)
router.delete('/:id', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query(
      'DELETE FROM skill WHERE skill_id = $1 RETURNING skill_id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found' });
    }

    res.json({ message: 'Skill deleted successfully', skill_id: id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
