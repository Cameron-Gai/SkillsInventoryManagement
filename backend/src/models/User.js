// User.js
// User model/schema definition
// This represents the structure of user data in the database

class User {
  constructor(data) {
    this.personId = data.person_id || data.personId;
    this.personName = data.person_name || data.personName;
    this.username = data.username;
    this.role = data.role || 'employee';
    this.managerPersonId = data.manager_person_id || data.managerPersonId;
    this.memberOfOrganizationId = data.member_of_organization_id || data.memberOfOrganizationId;
    this.isAdmin = data.is_admin !== undefined ? data.is_admin : (data.isAdmin !== undefined ? data.isAdmin : false);
    // Don't expose password in the model
    this.password = data.password; // Only for internal use, never in JSON
  }

  // Convert to JSON (exclude sensitive data)
  toJSON() {
    const { password, ...safeData } = this;
    return safeData;
  }

  // Convert to database format
  toDatabaseFormat() {
    return {
      person_id: this.personId,
      person_name: this.personName,
      username: this.username,
      role: this.role,
      manager_person_id: this.managerPersonId,
      member_of_organization_id: this.memberOfOrganizationId,
      is_admin: this.isAdmin,
    };
  }
}

module.exports = User;


