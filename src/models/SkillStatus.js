/**
 * SkillStatus Model
 * Represents the association between a person and a skill with proficiency level
 * Corresponds to the SkillStatus entity in the static diagram
 */
class SkillStatus {
  constructor(data) {
    this.skillStatusId = data.skillStatusId || data.skill_status_id;
    this.personId = data.personId || data.person_id;
    this.skillId = data.skillId || data.skill_id;
    this.level = data.level; // e.g., 'Beginner', 'Intermediate', 'Advanced', 'Expert'
    this.approvalStatus = data.approvalStatus || data.approval_status || 'PENDING';
    this.approvedBy = data.approvedBy || data.approved_by;
    this.timestamp = data.timestamp;
    this.createdAt = data.createdAt || data.created_at;
    this.updatedAt = data.updatedAt || data.updated_at;
  }

  /**
   * Convert to database format (snake_case)
   */
  toDatabase() {
    return {
      skill_status_id: this.skillStatusId,
      person_id: this.personId,
      skill_id: this.skillId,
      level: this.level,
      approval_status: this.approvalStatus,
      approved_by: this.approvedBy,
      timestamp: this.timestamp,
      created_at: this.createdAt,
      updated_at: this.updatedAt
    };
  }

  /**
   * Create from database row (snake_case to camelCase)
   */
  static fromDatabase(row) {
    if (!row) return null;
    return new SkillStatus({
      skillStatusId: row.skill_status_id,
      personId: row.person_id,
      skillId: row.skill_id,
      level: row.level,
      approvalStatus: row.approval_status,
      approvedBy: row.approved_by,
      timestamp: row.timestamp,
      createdAt: row.created_at,
      updatedAt: row.updated_at
    });
  }
}

module.exports = SkillStatus;
