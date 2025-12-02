const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');
const { ensureCompanyDesiredSkillsTable } = require('../utils/highValueSkillsTable');

const router = express.Router();
const companyDesiredRouter = express.Router();

companyDesiredRouter.get('/', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureCompanyDesiredSkillsTable();
    const result = await db.query(
      `SELECT c.id, c.skill_id, c.priority, c.notes, c.created_at, c.created_by, s.skill_name, s.skill_type
       FROM company_desired_skills c
       JOIN skill s ON s.skill_id = c.skill_id
       ORDER BY c.created_at DESC`
    );

    const payload = result.rows.map((row) => ({
      id: row.id,
      skill_id: row.skill_id,
      skill_name: row.skill_name,
      skill_type: row.skill_type,
      priority: row.priority,
      notes: row.notes || '',
      created_at: row.created_at,
      created_by: row.created_by,
    }));

    res.json(payload);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

companyDesiredRouter.post('/', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureCompanyDesiredSkillsTable();
    const { skill_id, priority = 'High', notes = '' } = req.body;

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    const insertResult = await db.query(
      `INSERT INTO company_desired_skills (skill_id, priority, notes, created_by)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (skill_id)
       DO UPDATE SET priority = EXCLUDED.priority, notes = EXCLUDED.notes
       RETURNING id`,
      [skill_id, priority, notes, req.user.person_id]
    );

    const detailResult = await db.query(
      `SELECT c.id, c.skill_id, c.priority, c.notes, c.created_at, c.created_by, s.skill_name, s.skill_type
       FROM company_desired_skills c
       JOIN skill s ON s.skill_id = c.skill_id
       WHERE c.id = $1`,
      [insertResult.rows[0].id]
    );

    const row = detailResult.rows[0];
    res.status(201).json({
      id: row.id,
      skill_id: row.skill_id,
      skill_name: row.skill_name,
      skill_type: row.skill_type,
      priority: row.priority,
      notes: row.notes || '',
      created_at: row.created_at,
      created_by: row.created_by,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

companyDesiredRouter.delete('/:id', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureCompanyDesiredSkillsTable();
    const { id } = req.params;
    const result = await db.query(
      'DELETE FROM company_desired_skills WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Company desired skill not found' });
    }

    res.json({ message: 'Company desired skill removed', id: Number(id) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

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

router.use('/company-desired', companyDesiredRouter);

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
