const searchRepository = require('../repositories/SearchRepository');
const auditRepository = require('../repositories/AuditRepository');

/**
 * SearchService
 * Business logic for talent search functionality
 * Implements FR-09, FR-11: Manager UI for talent search with multiple criteria
 */
class SearchService {
  /**
   * Search for talent based on multiple criteria
   * Supports FR-11: Search by skill, level, location/team, and recency
   * 
   * @param {Object} criteria - Search criteria
   * @param {string} criteria.skill - Skill name (partial match)
   * @param {string} criteria.level - Proficiency level
   * @param {string} criteria.team - Team name or ID
   * @param {string} criteria.location - Location/office
   * @param {number} criteria.daysRecent - Only include skills updated in last N days
   * @param {number} criteria.limit - Maximum results to return
   * @param {number} criteria.offset - Pagination offset
   * @param {number} searcherId - ID of the user performing the search (for audit)
   */
  async searchTalent(criteria, searcherId = null) {
    try {
      // Validate criteria
      if (!criteria || Object.keys(criteria).length === 0) {
        return {
          success: false,
          error: 'At least one search criterion must be provided'
        };
      }

      // Convert daysRecent to updatedAfter date
      if (criteria.daysRecent) {
        const daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - parseInt(criteria.daysRecent));
        criteria.updatedAfter = daysAgo;
      }

      // Execute search
      const results = await searchRepository.searchTalent(criteria);

      // Log search action for analytics/audit
      if (searcherId) {
        await auditRepository.createAuditLog({
          action: 'SEARCH',
          userId: searcherId,
          targetType: 'TALENT_SEARCH',
          targetId: null,
          oldValue: null,
          newValue: { criteria, resultCount: results.length },
          reason: 'Manager talent search',
          timestamp: new Date()
        });
      }

      // Rank results by relevance
      const rankedResults = this._rankResults(results, criteria);

      return {
        success: true,
        data: rankedResults,
        count: rankedResults.length,
        criteria: criteria
      };
    } catch (error) {
      console.error('Error searching talent:', error);
      throw new Error('Failed to search talent');
    }
  }

  /**
   * Search for people who have ALL specified skills
   * @param {Array<string>} skills - Array of skill names required
   * @param {Object} additionalFilters - Additional filters (level, team, location)
   * @param {number} searcherId - ID of the user performing the search
   */
  async searchByMultipleSkills(skills, additionalFilters = {}, searcherId = null) {
    try {
      if (!skills || skills.length === 0) {
        return {
          success: false,
          error: 'At least one skill must be specified'
        };
      }

      const results = await searchRepository.searchByMultipleSkills(skills, additionalFilters);

      // Log search action
      if (searcherId) {
        await auditRepository.createAuditLog({
          action: 'SEARCH',
          userId: searcherId,
          targetType: 'MULTI_SKILL_SEARCH',
          targetId: null,
          oldValue: null,
          newValue: { skills, additionalFilters, resultCount: results.length },
          reason: 'Manager multi-skill search',
          timestamp: new Date()
        });
      }

      return {
        success: true,
        data: results,
        count: results.length,
        requiredSkills: skills
      };
    } catch (error) {
      console.error('Error searching by multiple skills:', error);
      throw new Error('Failed to search by multiple skills');
    }
  }

  /**
   * Get detailed profile for a specific person including all their skills
   * @param {number} personId - ID of the person to get profile for
   * @param {number} requesterId - ID of the user requesting the profile
   */
  async getPersonProfile(personId, requesterId = null) {
    try {
      const profile = await searchRepository.getPersonSkillProfile(personId);

      if (!profile) {
        return {
          success: false,
          error: 'Person not found'
        };
      }

      // Log profile view
      if (requesterId) {
        await auditRepository.createAuditLog({
          action: 'VIEW_PROFILE',
          userId: requesterId,
          targetType: 'PERSON',
          targetId: personId,
          oldValue: null,
          newValue: null,
          reason: 'Manager viewed employee profile',
          timestamp: new Date()
        });
      }

      return {
        success: true,
        data: profile
      };
    } catch (error) {
      console.error('Error fetching person profile:', error);
      throw new Error('Failed to fetch person profile');
    }
  }

  /**
   * Generate report/statistics for skill distribution
   * @param {Object} filters - Filters for statistics (skill, team)
   * @param {number} reporterId - ID of the user generating the report
   */
  async generateSkillReport(filters = {}, reporterId = null) {
    try {
      const statistics = await searchRepository.getSkillStatistics(filters);

      // Log report generation
      if (reporterId) {
        await auditRepository.createAuditLog({
          action: 'GENERATE_REPORT',
          userId: reporterId,
          targetType: 'SKILL_REPORT',
          targetId: null,
          oldValue: null,
          newValue: { filters, skillCount: statistics.length },
          reason: 'Manager generated skill report',
          timestamp: new Date()
        });
      }

      return {
        success: true,
        data: {
          statistics: statistics,
          summary: {
            totalSkills: statistics.length,
            totalEmployees: statistics.reduce((sum, stat) => sum + parseInt(stat.person_count), 0),
            filters: filters
          },
          generatedAt: new Date()
        }
      };
    } catch (error) {
      console.error('Error generating skill report:', error);
      throw new Error('Failed to generate skill report');
    }
  }

  /**
   * Advanced search with scoring and ranking
   * @param {Object} criteria - Search criteria with weights
   * @param {number} searcherId - ID of the user performing the search
   */
  async advancedSearch(criteria, searcherId = null) {
    try {
      // Perform basic search first
      const baseResults = await searchRepository.searchTalent(criteria);

      // Apply advanced ranking with multiple factors
      const scoredResults = baseResults.map(person => {
        let score = 0;
        
        // Score based on skill level matches
        person.skills.forEach(skill => {
          if (criteria.level && skill.level === criteria.level) {
            score += 10;
          }
          if (skill.level === 'Expert') score += 5;
          else if (skill.level === 'Advanced') score += 3;
          else if (skill.level === 'Intermediate') score += 2;
          else if (skill.level === 'Beginner') score += 1;
          
          // Boost for recent updates
          const daysSinceUpdate = Math.floor((new Date() - new Date(skill.timestamp)) / (1000 * 60 * 60 * 24));
          if (daysSinceUpdate < 30) score += 5;
          else if (daysSinceUpdate < 90) score += 3;
          else if (daysSinceUpdate < 180) score += 1;
        });

        return {
          ...person,
          relevanceScore: score
        };
      });

      // Sort by relevance score
      scoredResults.sort((a, b) => b.relevanceScore - a.relevanceScore);

      // Log search
      if (searcherId) {
        await auditRepository.createAuditLog({
          action: 'ADVANCED_SEARCH',
          userId: searcherId,
          targetType: 'TALENT_SEARCH',
          targetId: null,
          oldValue: null,
          newValue: { criteria, resultCount: scoredResults.length },
          reason: 'Manager advanced talent search',
          timestamp: new Date()
        });
      }

      return {
        success: true,
        data: scoredResults,
        count: scoredResults.length,
        criteria: criteria
      };
    } catch (error) {
      console.error('Error performing advanced search:', error);
      throw new Error('Failed to perform advanced search');
    }
  }

  /**
   * Private method to rank search results by relevance
   * @private
   */
  _rankResults(results, criteria) {
    return results.map(person => {
      let relevanceScore = 0;

      // Score based on number of matching skills
      if (person.skills && person.skills.length > 0) {
        relevanceScore += person.skills.length * 2;

        // Higher score for exact skill name match
        if (criteria.skill) {
          const hasExactMatch = person.skills.some(skill => 
            skill.skillName.toLowerCase() === criteria.skill.toLowerCase()
          );
          if (hasExactMatch) relevanceScore += 10;
        }

        // Score for matching level
        if (criteria.level) {
          const hasLevelMatch = person.skills.some(skill => 
            skill.level === criteria.level
          );
          if (hasLevelMatch) relevanceScore += 5;
        }
      }

      return {
        ...person,
        relevanceScore
      };
    }).sort((a, b) => b.relevanceScore - a.relevanceScore);
  }

  /**
   * Save a search query for future use
   * @param {number} userId - User saving the search
   * @param {string} searchName - Name for the saved search
   * @param {Object} criteria - Search criteria to save
   */
  async saveSearch(userId, searchName, criteria) {
    try {
      await auditRepository.createAuditLog({
        action: 'SAVE_SEARCH',
        userId: userId,
        targetType: 'SAVED_SEARCH',
        targetId: null,
        oldValue: null,
        newValue: { searchName, criteria },
        reason: 'Manager saved search query',
        timestamp: new Date()
      });

      return {
        success: true,
        message: 'Search saved successfully',
        data: { searchName, criteria }
      };
    } catch (error) {
      console.error('Error saving search:', error);
      throw new Error('Failed to save search');
    }
  }
}

module.exports = new SearchService();
