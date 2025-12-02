const db = require('../config/database');
const Person = require('../models/Person');
const Team = require('../models/Team');

/**
 * SearchRepository
 * Handles complex database queries for talent search functionality
 * Supports FR-09 and FR-11: talent pool search with multiple filters
 */
class SearchRepository {
  /**
   * Search for people by multiple criteria
   * @param {Object} filters - Search filters
   * @param {string} filters.skill - Skill name to search for
   * @param {string} filters.level - Proficiency level (Beginner, Intermediate, Advanced, Expert)
   * @param {string} filters.team - Team name or ID
   * @param {string} filters.location - Location/office
   * @param {Date} filters.updatedAfter - Only include skills updated after this date
   * @param {number} filters.limit - Maximum number of results
   * @param {number} filters.offset - Pagination offset
   */
  async searchTalent(filters = {}) {
    let query = `
      SELECT DISTINCT
        p.person_id, p.first_name, p.last_name, p.username, p.email, p.location,
        t.team_id, t.team_name,
        ss.skill_status_id, ss.skill_id, ss.level, ss.timestamp, ss.approval_status,
        s.name as skill_name, s.category, s.description,
        MAX(ss.timestamp) as last_updated
      FROM persons p
      LEFT JOIN teams t ON p.team_id = t.team_id
      INNER JOIN skill_status ss ON p.person_id = ss.person_id
      INNER JOIN skills s ON ss.skill_id = s.skill_id
      WHERE ss.approval_status = 'APPROVED'
    `;

    const params = [];
    let paramIndex = 1;

    // Filter by skill name (partial match, case-insensitive)
    if (filters.skill) {
      query += ` AND LOWER(s.name) LIKE LOWER($${paramIndex})`;
      params.push(`%${filters.skill}%`);
      paramIndex++;
    }

    // Filter by proficiency level
    if (filters.level) {
      query += ` AND ss.level = $${paramIndex}`;
      params.push(filters.level);
      paramIndex++;
    }

    // Filter by team
    if (filters.team) {
      query += ` AND (t.team_name ILIKE $${paramIndex} OR t.team_id::text = $${paramIndex})`;
      params.push(`%${filters.team}%`);
      paramIndex++;
    }

    // Filter by location
    if (filters.location) {
      query += ` AND p.location ILIKE $${paramIndex}`;
      params.push(`%${filters.location}%`);
      paramIndex++;
    }

    // Filter by recency (skills updated after a certain date)
    if (filters.updatedAfter) {
      query += ` AND ss.timestamp >= $${paramIndex}`;
      params.push(filters.updatedAfter);
      paramIndex++;
    }

    // Group by to get the most recent update per person-skill combination
    query += `
      GROUP BY p.person_id, p.first_name, p.last_name, p.username, p.email, p.location,
               t.team_id, t.team_name,
               ss.skill_status_id, ss.skill_id, ss.level, ss.timestamp, ss.approval_status,
               s.name, s.category, s.description
      ORDER BY last_updated DESC, p.last_name ASC, p.first_name ASC
    `;

    // Apply pagination
    const limit = filters.limit || 50;
    const offset = filters.offset || 0;
    query += ` LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
    params.push(limit, offset);

    const result = await db.query(query, params);

    // Transform results into structured format
    return this._groupResultsByPerson(result.rows);
  }

  /**
   * Search for people with specific skills (returns people who have ALL specified skills)
   * @param {Array<string>} skillNames - Array of skill names to match
   * @param {Object} additionalFilters - Additional filters (level, team, location)
   */
  async searchByMultipleSkills(skillNames = [], additionalFilters = {}) {
    if (skillNames.length === 0) {
      return [];
    }

    let query = `
      SELECT
        p.person_id, p.first_name, p.last_name, p.username, p.email, p.location,
        t.team_id, t.team_name,
        COUNT(DISTINCT ss.skill_id) as matched_skills_count
      FROM persons p
      LEFT JOIN teams t ON p.team_id = t.team_id
      INNER JOIN skill_status ss ON p.person_id = ss.person_id
      INNER JOIN skills s ON ss.skill_id = s.skill_id
      WHERE ss.approval_status = 'APPROVED'
        AND LOWER(s.name) = ANY($1::text[])
    `;

    const params = [skillNames.map(s => s.toLowerCase())];
    let paramIndex = 2;

    // Additional filters
    if (additionalFilters.level) {
      query += ` AND ss.level = $${paramIndex}`;
      params.push(additionalFilters.level);
      paramIndex++;
    }

    if (additionalFilters.team) {
      query += ` AND (t.team_name ILIKE $${paramIndex} OR t.team_id::text = $${paramIndex})`;
      params.push(`%${additionalFilters.team}%`);
      paramIndex++;
    }

    if (additionalFilters.location) {
      query += ` AND p.location ILIKE $${paramIndex}`;
      params.push(`%${additionalFilters.location}%`);
      paramIndex++;
    }

    query += `
      GROUP BY p.person_id, p.first_name, p.last_name, p.username, p.email, p.location,
               t.team_id, t.team_name
      HAVING COUNT(DISTINCT ss.skill_id) = $${paramIndex}
      ORDER BY p.last_name ASC, p.first_name ASC
    `;
    params.push(skillNames.length);

    const result = await db.query(query, params);
    return result.rows.map(row => ({
      personId: row.person_id,
      firstName: row.first_name,
      lastName: row.last_name,
      username: row.username,
      email: row.email,
      location: row.location,
      teamId: row.team_id,
      teamName: row.team_name,
      matchedSkillsCount: parseInt(row.matched_skills_count)
    }));
  }

  /**
   * Get detailed skill profile for a person
   */
  async getPersonSkillProfile(personId) {
    const query = `
      SELECT
        p.person_id, p.first_name, p.last_name, p.username, p.email, p.location, p.role,
        t.team_id, t.team_name, t.location as team_location,
        ss.skill_status_id, ss.skill_id, ss.level, ss.timestamp, ss.approval_status,
        s.name as skill_name, s.category, s.description
      FROM persons p
      LEFT JOIN teams t ON p.team_id = t.team_id
      LEFT JOIN skill_status ss ON p.person_id = ss.person_id
      LEFT JOIN skills s ON ss.skill_id = s.skill_id
      WHERE p.person_id = $1 AND (ss.approval_status = 'APPROVED' OR ss.approval_status IS NULL)
      ORDER BY s.category, s.name
    `;

    const result = await db.query(query, [personId]);
    if (result.rows.length === 0) {
      return null;
    }

    const personData = result.rows[0];
    const skills = result.rows
      .filter(row => row.skill_id !== null)
      .map(row => ({
        skillId: row.skill_id,
        skillName: row.skill_name,
        category: row.category,
        description: row.description,
        level: row.level,
        timestamp: row.timestamp,
        approvalStatus: row.approval_status
      }));

    return {
      personId: personData.person_id,
      firstName: personData.first_name,
      lastName: personData.last_name,
      username: personData.username,
      email: personData.email,
      location: personData.location,
      role: personData.role,
      team: {
        teamId: personData.team_id,
        teamName: personData.team_name,
        location: personData.team_location
      },
      skills: skills
    };
  }

  /**
   * Get aggregated statistics for search results
   */
  async getSkillStatistics(filters = {}) {
    let query = `
      SELECT
        s.name as skill_name,
        s.category,
        COUNT(DISTINCT ss.person_id) as person_count,
        COUNT(CASE WHEN ss.level = 'Expert' THEN 1 END) as expert_count,
        COUNT(CASE WHEN ss.level = 'Advanced' THEN 1 END) as advanced_count,
        COUNT(CASE WHEN ss.level = 'Intermediate' THEN 1 END) as intermediate_count,
        COUNT(CASE WHEN ss.level = 'Beginner' THEN 1 END) as beginner_count
      FROM skills s
      INNER JOIN skill_status ss ON s.skill_id = ss.skill_id
      INNER JOIN persons p ON ss.person_id = p.person_id
      LEFT JOIN teams t ON p.team_id = t.team_id
      WHERE ss.approval_status = 'APPROVED'
    `;

    const params = [];
    let paramIndex = 1;

    if (filters.skill) {
      query += ` AND LOWER(s.name) LIKE LOWER($${paramIndex})`;
      params.push(`%${filters.skill}%`);
      paramIndex++;
    }

    if (filters.team) {
      query += ` AND (t.team_name ILIKE $${paramIndex} OR t.team_id::text = $${paramIndex})`;
      params.push(`%${filters.team}%`);
      paramIndex++;
    }

    query += `
      GROUP BY s.name, s.category
      ORDER BY person_count DESC, s.name ASC
    `;

    const result = await db.query(query, params);
    return result.rows;
  }

  /**
   * Helper method to group search results by person
   * @private
   */
  _groupResultsByPerson(rows) {
    const personMap = new Map();

    rows.forEach(row => {
      const personId = row.person_id;

      if (!personMap.has(personId)) {
        personMap.set(personId, {
          personId: row.person_id,
          firstName: row.first_name,
          lastName: row.last_name,
          username: row.username,
          email: row.email,
          location: row.location,
          team: {
            teamId: row.team_id,
            teamName: row.team_name
          },
          skills: []
        });
      }

      const person = personMap.get(personId);
      person.skills.push({
        skillStatusId: row.skill_status_id,
        skillId: row.skill_id,
        skillName: row.skill_name,
        category: row.category,
        level: row.level,
        timestamp: row.timestamp,
        lastUpdated: row.last_updated
      });
    });

    return Array.from(personMap.values());
  }
}

module.exports = new SearchRepository();
