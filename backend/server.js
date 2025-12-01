const express = require('express');
const dotenv = require('dotenv');
dotenv.config();
const cors = require('cors');
const config = require('./src/config/config');
const authRoutes = require('./src/routes/authRoutes');
const { authenticate } = require('./src/config/auth/authMiddleware');
const { authorizeRoles } = require('./src/config/auth/requireRole');
const db = require('./src/config/db');

const app = express();

// Middleware
app.use(cors({
  origin: config.cors.origin,
  credentials: true,
}));

app.use(express.json());

// Login routes
app.use('/api', authRoutes);

// Example protected route
app.get('/api/skills', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM skill');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Health check
app.get('/health', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW()');
    res.status(200).json({ status: 'OK', timestamp: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
