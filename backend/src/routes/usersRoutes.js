const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

//get current user profile
router.get('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    
    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person WHERE person_id = $1',
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];

    res.json({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update user profile
router.put('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { person_name } = req.body;

    if (!person_name) {
      return res.status(400).json({ error: 'person_name is required' });
    }

    const result = await db.query(
      'UPDATE person SET person_name = $1 WHERE person_id = $2 RETURNING person_id, person_name, is_admin',
      [person_name, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      name: result.rows[0].person_name,
      is_admin: result.rows[0].is_admin,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all users (admin/manager only)
router.get('/', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person ORDER BY person_name'
    );

    const users = result.rows.map(user => ({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
    }));

    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get a specific user by ID (admin/manager only)
router.get('/:id', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person WHERE person_id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];
    res.json({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete user (admin only)
router.delete('/:id', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    // Prevent deleting yourself
    if (req.user.person_id === parseInt(id)) {
      return res.status(400).json({ error: 'Cannot delete your own account' });
    }

    const result = await db.query(
      'DELETE FROM person WHERE person_id = $1 RETURNING person_id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ message: 'User deleted successfully', person_id: id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
