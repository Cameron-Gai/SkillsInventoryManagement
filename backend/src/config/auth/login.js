const express = require('express');
const jwt = require('jsonwebtoken');
const db = require('../db');
const { comparePassword } = require('../../utils/hash');   // FIXED PATH

const router = express.Router();

router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Fetch user by username
    const result = await db.query(
      'SELECT person_id, person_name, username, password, role FROM person WHERE username = $1',
      [username]
    );

    if (result.rows.length === 0)
      return res.status(401).json({ error: 'Invalid credentials' });

    const user = result.rows[0];

    // Compare password
    const validPassword = await comparePassword(password, user.password);
    if (!validPassword)
      return res.status(401).json({ error: 'Invalid credentials' });

    // Create JWT
    const token = jwt.sign(
      {
        person_id: user.person_id,
        username: user.username,
        role: user.role
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '24h' }
    );

    return res.json({
      message: 'Login successful',
      token,
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role
    });

  } catch (err) {
    console.error('Login error:', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
