const express = require('express');
const router = express.Router();
const searchController = require('../controllers/SearchController');

/**
 * Search Routes
 * Endpoints for talent search and reporting functionality
 * Base path: /api/search
 */

// POST /api/search/talent - Search for talent by multiple criteria
router.post('/talent', searchController.searchTalent.bind(searchController));

// POST /api/search/multiple-skills - Search for people with all specified skills
router.post('/multiple-skills', searchController.searchByMultipleSkills.bind(searchController));

// POST /api/search/advanced - Advanced search with ranking
router.post('/advanced', searchController.advancedSearch.bind(searchController));

// GET /api/search/person/:personId - Get detailed profile for a person
router.get('/person/:personId', searchController.getPersonProfile.bind(searchController));

// POST /api/search/report - Generate skill distribution report
router.post('/report', searchController.generateSkillReport.bind(searchController));

// POST /api/search/save - Save a search query
router.post('/save', searchController.saveSearch.bind(searchController));

// GET /api/search/filters - Get available filter options
router.get('/filters', searchController.getFilterOptions.bind(searchController));

module.exports = router;
