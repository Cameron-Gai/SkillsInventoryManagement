const express = require('express');
const cors = require('cors');
const config = require('./src/config/config');

// Initialize database connection
require('./src/config/database');

const app = express();

// Middleware
app.use(cors({
  origin: config.cors.origin,
  credentials: true,
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Basic health check route
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    environment: config.server.env
  });
});

// API routes
const userRoutes = require('./src/routes/userRoutes');
app.use(`${config.api.baseUrl}/${config.api.version}/users`, userRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Cannot ${req.method} ${req.url}`
  });
});

// Error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: err.message || 'Internal Server Error',
    ...(config.server.env === 'development' && { stack: err.stack })
  });
});

// Start server
const PORT = config.server.port;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT} in ${config.server.env} mode`);
  console.log(`Health check available at http://localhost:${PORT}/health`);
});

module.exports = app;
