/**
 * Team Model
 * Represents a team/department in the organization
 * Corresponds to the Team entity in the static diagram
 */
class Team {
  constructor(data) {
    this.teamId = data.teamId || data.team_id;
    this.teamName = data.teamName || data.team_name;
    this.description = data.description;
    this.managerId = data.managerId || data.manager_id;
    this.location = data.location;
    this.createdAt = data.createdAt || data.created_at;
    this.updatedAt = data.updatedAt || data.updated_at;
  }

  /**
   * Convert to database format (snake_case)
   */
  toDatabase() {
    return {
      team_id: this.teamId,
      team_name: this.teamName,
      description: this.description,
      manager_id: this.managerId,
      location: this.location,
      created_at: this.createdAt,
      updated_at: this.updatedAt
    };
  }

  /**
   * Create from database row (snake_case to camelCase)
   */
  static fromDatabase(row) {
    if (!row) return null;
    return new Team({
      teamId: row.team_id,
      teamName: row.team_name,
      description: row.description,
      managerId: row.manager_id,
      location: row.location,
      createdAt: row.created_at,
      updatedAt: row.updated_at
    });
  }
}

module.exports = Team;
