const express = require('express');
const dotenv = require('dotenv');
dotenv.config();
const cors = require('cors');
const config = require('./src/config/config');
const authRoutes = require('./src/routes/authRoutes');
const usersRoutes = require('./src/routes/usersRoutes');
const skillsRoutes = require('./src/routes/skillsRoutes');
const personSkillsRoutes = require('./src/routes/personSkillsRoutes');
const teamRoutes = require('./src/routes/teamRoutes');
const db = require('./src/config/db');

const app = express();

// Middleware
app.use(cors({
  origin: config.cors.origin,
  credentials: true,
}));

app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.json({ message: 'Skills Inventory Management API', version: '1.0.0' });
});

// Auth routes
app.use('/api', authRoutes);

// Users routes
app.use('/api/users', usersRoutes);

// Skills routes
app.use('/api/skills', skillsRoutes);

// Person Skills routes
app.use('/api/person-skills', personSkillsRoutes);

// Team routes
app.use('/api/team', teamRoutes);

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
