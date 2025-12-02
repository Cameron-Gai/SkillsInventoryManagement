const searchService = require('../services/SearchService');

/**
 * SearchController
 * Handles HTTP requests for talent search functionality
 * Endpoints for managers to search for employees by skills, level, team, and other criteria
 */
class SearchController {
  /**
   * POST /api/search/talent
   * Search for talent based on multiple criteria
   * Body: { skill, level, team, location, daysRecent, limit, offset }
   */
  async searchTalent(req, res) {
    try {
      const criteria = {
        skill: req.body.skill,
        level: req.body.level,
        team: req.body.team,
        location: req.body.location,
        daysRecent: req.body.daysRecent,
        limit: req.body.limit || 50,
        offset: req.body.offset || 0
      };

      // Get searcher ID from request (assuming authentication middleware sets req.user)
      const searcherId = req.body.searcherId || req.user?.id || null;

      // Remove undefined/null values
      Object.keys(criteria).forEach(key => 
        (criteria[key] === undefined || criteria[key] === null) && delete criteria[key]
      );

      const result = await searchService.searchTalent(criteria, searcherId);

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data,
          count: result.count,
          criteria: result.criteria
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in searchTalent:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/search/multiple-skills
   * Search for people who have ALL specified skills
   * Body: { skills: [], level, team, location }
   */
  async searchByMultipleSkills(req, res) {
    try {
      const { skills, level, team, location, searcherId } = req.body;

      if (!skills || !Array.isArray(skills) || skills.length === 0) {
        return res.status(400).json({
          success: false,
          error: 'Array of skills is required'
        });
      }

      const additionalFilters = {};
      if (level) additionalFilters.level = level;
      if (team) additionalFilters.team = team;
      if (location) additionalFilters.location = location;

      const result = await searchService.searchByMultipleSkills(
        skills,
        additionalFilters,
        searcherId || req.user?.id || null
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data,
          count: result.count,
          requiredSkills: result.requiredSkills
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in searchByMultipleSkills:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * GET /api/search/person/:personId
   * Get detailed skill profile for a specific person
   */
  async getPersonProfile(req, res) {
    try {
      const { personId } = req.params;
      const requesterId = req.query.requesterId || req.user?.id || null;

      const result = await searchService.getPersonProfile(
        parseInt(personId),
        requesterId
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data
        });
      } else {
        res.status(404).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in getPersonProfile:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/search/report
   * Generate skill distribution report
   * Body: { skill, team, reporterId }
   */
  async generateSkillReport(req, res) {
    try {
      const filters = {};
      if (req.body.skill) filters.skill = req.body.skill;
      if (req.body.team) filters.team = req.body.team;

      const reporterId = req.body.reporterId || req.user?.id || null;

      const result = await searchService.generateSkillReport(filters, reporterId);

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in generateSkillReport:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/search/advanced
   * Advanced search with scoring and ranking
   * Body: { skill, level, team, location, daysRecent, searcherId }
   */
  async advancedSearch(req, res) {
    try {
      const criteria = {
        skill: req.body.skill,
        level: req.body.level,
        team: req.body.team,
        location: req.body.location,
        daysRecent: req.body.daysRecent
      };

      // Remove undefined/null values
      Object.keys(criteria).forEach(key => 
        (criteria[key] === undefined || criteria[key] === null) && delete criteria[key]
      );

      if (Object.keys(criteria).length === 0) {
        return res.status(400).json({
          success: false,
          error: 'At least one search criterion must be provided'
        });
      }

      const searcherId = req.body.searcherId || req.user?.id || null;

      const result = await searchService.advancedSearch(criteria, searcherId);

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data,
          count: result.count,
          criteria: result.criteria
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in advancedSearch:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/search/save
   * Save a search query for future use
   * Body: { userId, searchName, criteria }
   */
  async saveSearch(req, res) {
    try {
      const { userId, searchName, criteria } = req.body;

      if (!userId || !searchName || !criteria) {
        return res.status(400).json({
          success: false,
          error: 'userId, searchName, and criteria are required'
        });
      }

      const result = await searchService.saveSearch(userId, searchName, criteria);

      if (result.success) {
        res.status(201).json({
          success: true,
          message: result.message,
          data: result.data
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in saveSearch:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * GET /api/search/filters
   * Get available filter options (for UI dropdowns)
   */
  async getFilterOptions(req, res) {
    try {
      // This could be enhanced to fetch from database
      const filterOptions = {
        levels: ['Beginner', 'Intermediate', 'Advanced', 'Expert'],
        recencyOptions: [
          { label: 'Last 7 days', value: 7 },
          { label: 'Last 30 days', value: 30 },
          { label: 'Last 90 days', value: 90 },
          { label: 'Last 180 days', value: 180 },
          { label: 'Last year', value: 365 }
        ]
      };

      res.status(200).json({
        success: true,
        data: filterOptions
      });
    } catch (error) {
      console.error('Error in getFilterOptions:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }
}

module.exports = new SearchController();
