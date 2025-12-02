/**
 * Skill Model
 * Represents a skill in the system with its attributes and status
 */
class Skill {
  constructor(data) {
    this.skillId = data.skillId || data.skill_id;
    this.name = data.name;
    this.category = data.category;
    this.description = data.description;
    this.status = data.status || 'PENDING'; // PENDING, APPROVED, REJECTED
    this.createdAt = data.createdAt || data.created_at;
    this.updatedAt = data.updatedAt || data.updated_at;
  }

  /**
   * Convert to database format (snake_case)
   */
  toDatabase() {
    return {
      skill_id: this.skillId,
      name: this.name,
      category: this.category,
      description: this.description,
      status: this.status,
      created_at: this.createdAt,
      updated_at: this.updatedAt
    };
  }

  /**
   * Create from database row (snake_case to camelCase)
   */
  static fromDatabase(row) {
    if (!row) return null;
    return new Skill({
      skillId: row.skill_id,
      name: row.name,
      category: row.category,
      description: row.description,
      status: row.status,
      createdAt: row.created_at,
      updatedAt: row.updated_at
    });
  }
}

module.exports = Skill;
