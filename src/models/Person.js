/**
 * Person Model
 * Represents an employee/user in the system
 * Corresponds to the Person entity in the static diagram
 */
class Person {
  constructor(data) {
    this.personId = data.personId || data.person_id;
    this.firstName = data.firstName || data.first_name;
    this.lastName = data.lastName || data.last_name;
    this.username = data.username;
    this.email = data.email;
    this.role = data.role; // 'EMPLOYEE', 'MANAGER', 'ADMIN'
    this.teamId = data.teamId || data.team_id;
    this.location = data.location;
    this.createdAt = data.createdAt || data.created_at;
    this.updatedAt = data.updatedAt || data.updated_at;
  }

  /**
   * Convert to database format (snake_case)
   */
  toDatabase() {
    return {
      person_id: this.personId,
      first_name: this.firstName,
      last_name: this.lastName,
      username: this.username,
      email: this.email,
      role: this.role,
      team_id: this.teamId,
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
    return new Person({
      personId: row.person_id,
      firstName: row.first_name,
      lastName: row.last_name,
      username: row.username,
      email: row.email,
      role: row.role,
      teamId: row.team_id,
      location: row.location,
      createdAt: row.created_at,
      updatedAt: row.updated_at
    });
  }

  /**
   * Get full name
   */
  getFullName() {
    return `${this.firstName} ${this.lastName}`;
  }
}

module.exports = Person;
