const express = require('express');
const router = express.Router();

// Import route modules
const approvalRoutes = require('./approvalRoutes');
const searchRoutes = require('./searchRoutes');

/**
 * Main API Router
 * Aggregates all route modules
 * Base path: /api
 */

// Mount approval routes
router.use('/approvals', approvalRoutes);

// Mount search routes
router.use('/search', searchRoutes);

// API documentation endpoint
router.get('/', (req, res) => {
  res.json({
    message: 'Skills Inventory Management API',
    version: '1.0.0',
    endpoints: {
      approvals: {
        'GET /api/approvals/pending': 'Get pending skill submissions',
        'POST /api/approvals/:skillStatusId/approve': 'Approve a skill submission',
        'POST /api/approvals/:skillStatusId/reject': 'Reject a skill submission',
        'POST /api/approvals/batch/approve': 'Batch approve submissions',
        'GET /api/approvals/:skillStatusId/history': 'Get approval history',
        'GET /api/approvals/statistics': 'Get approval statistics'
      },
      search: {
        'POST /api/search/talent': 'Search for talent by criteria',
        'POST /api/search/multiple-skills': 'Search by multiple skills',
        'POST /api/search/advanced': 'Advanced search with ranking',
        'GET /api/search/person/:personId': 'Get person skill profile',
        'POST /api/search/report': 'Generate skill report',
        'POST /api/search/save': 'Save a search query',
        'GET /api/search/filters': 'Get filter options'
      }
    }
  });
});

module.exports = router;
