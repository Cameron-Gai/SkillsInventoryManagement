const db = require('../config/database');
const SkillStatus = require('../models/SkillStatus');
const Skill = require('../models/Skill');

/**
 * SkillRepository
 * Handles database operations for Skills and SkillStatus entities
 */
class SkillRepository {
  /**
   * Get a skill status by ID
   */
  async getSkillStatusById(skillStatusId) {
    const query = `
      SELECT ss.*, s.name as skill_name, s.category, s.description,
             p.first_name, p.last_name, p.email, p.team_id, t.team_name
      FROM skill_status ss
      JOIN skills s ON ss.skill_id = s.skill_id
      JOIN persons p ON ss.person_id = p.person_id
      LEFT JOIN teams t ON p.team_id = t.team_id
      WHERE ss.skill_status_id = $1
    `;
    const result = await db.query(query, [skillStatusId]);
    return result.rows.length > 0 ? SkillStatus.fromDatabase(result.rows[0]) : null;
  }

  /**
   * Get all pending skill submissions for manager approval
   */
  async getPendingSkillStatuses() {
    const query = `
      SELECT ss.*, s.name as skill_name, s.category, s.description,
             p.first_name, p.last_name, p.email, p.username, p.team_id, t.team_name
      FROM skill_status ss
      JOIN skills s ON ss.skill_id = s.skill_id
      JOIN persons p ON ss.person_id = p.person_id
      LEFT JOIN teams t ON p.team_id = t.team_id
      WHERE ss.approval_status = 'PENDING'
      ORDER BY ss.timestamp DESC
    `;
    const result = await db.query(query);
    return result.rows.map(row => ({
      ...SkillStatus.fromDatabase(row),
      skillName: row.skill_name,
      category: row.category,
      description: row.description,
      employeeName: `${row.first_name} ${row.last_name}`,
      email: row.email,
      username: row.username,
      teamName: row.team_name
    }));
  }

  /**
   * Update skill status approval
   */
  async updateSkillStatusApproval(skillStatusId, approvalStatus, approvedBy) {
    const query = `
      UPDATE skill_status
      SET approval_status = $1,
          approved_by = $2,
          updated_at = NOW()
      WHERE skill_status_id = $3
      RETURNING *
    `;
    const result = await db.query(query, [approvalStatus, approvedBy, skillStatusId]);
    return result.rows.length > 0 ? SkillStatus.fromDatabase(result.rows[0]) : null;
  }

  /**
   * Get skill by ID
   */
  async getSkillById(skillId) {
    const query = `SELECT * FROM skills WHERE skill_id = $1`;
    const result = await db.query(query, [skillId]);
    return result.rows.length > 0 ? Skill.fromDatabase(result.rows[0]) : null;
  }

  /**
   * Update skill status (PENDING, APPROVED, REJECTED)
   */
  async updateSkillStatus(skillId, status) {
    const query = `
      UPDATE skills
      SET status = $1,
          updated_at = NOW()
      WHERE skill_id = $2
      RETURNING *
    `;
    const result = await db.query(query, [status, skillId]);
    return result.rows.length > 0 ? Skill.fromDatabase(result.rows[0]) : null;
  }

  /**
   * Get skill statuses by person ID
   */
  async getSkillStatusesByPersonId(personId) {
    const query = `
      SELECT ss.*, s.name as skill_name, s.category, s.description
      FROM skill_status ss
      JOIN skills s ON ss.skill_id = s.skill_id
      WHERE ss.person_id = $1
      ORDER BY ss.timestamp DESC
    `;
    const result = await db.query(query, [personId]);
    return result.rows.map(row => ({
      ...SkillStatus.fromDatabase(row),
      skillName: row.skill_name,
      category: row.category,
      description: row.description
    }));
  }

  /**
   * Create or update skill status
   */
  async upsertSkillStatus(skillStatusData) {
    const query = `
      INSERT INTO skill_status (person_id, skill_id, level, approval_status, timestamp, created_at, updated_at)
      VALUES ($1, $2, $3, $4, NOW(), NOW(), NOW())
      ON CONFLICT (person_id, skill_id)
      DO UPDATE SET
        level = EXCLUDED.level,
        approval_status = EXCLUDED.approval_status,
        timestamp = NOW(),
        updated_at = NOW()
      RETURNING *
    `;
    const result = await db.query(query, [
      skillStatusData.personId,
      skillStatusData.skillId,
      skillStatusData.level,
      skillStatusData.approvalStatus || 'PENDING'
    ]);
    return result.rows.length > 0 ? SkillStatus.fromDatabase(result.rows[0]) : null;
  }
}

module.exports = new SkillRepository();
