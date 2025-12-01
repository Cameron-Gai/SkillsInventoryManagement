// userRepository.js
// Data access layer for user operations
// Handles all database queries related to users

const pool = require('../config/database');
const User = require('../models/User');

class UserRepository {
  /**
   * Find user by ID
   * @param {number} userId - Person ID
   * @returns {Promise<User|null>}
   */
  async findById(userId) {
    try {
      const result = await pool.query(
        'SELECT person_id, person_name, username, role, manager_person_id, member_of_organization_id, is_admin FROM person WHERE person_id = $1',
        [userId]
      );

      if (result.rows.length === 0) {
        return null;
      }

      return new User(result.rows[0]);
    } catch (error) {
      console.error('Error finding user by ID:', error);
      throw error;
    }
  }

  /**
   * Find user by username
   * @param {string} username - Username
   * @returns {Promise<User|null>}
   */
  async findByUsername(username) {
    try {
      const result = await pool.query(
        'SELECT person_id, person_name, username, role, manager_person_id, member_of_organization_id, is_admin, password FROM person WHERE username = $1',
        [username]
      );

      if (result.rows.length === 0) {
        return null;
      }

      return new User(result.rows[0]);
    } catch (error) {
      console.error('Error finding user by username:', error);
      throw error;
    }
  }

  /**
   * Find user by email (alias for findByUsername for backward compatibility)
   * @param {string} email - Username/email
   * @returns {Promise<User|null>}
   */
  async findByEmail(email) {
    return this.findByUsername(email);
  }

  /**
   * Update user profile
   * @param {number} userId - Person ID
   * @param {Object} updateData - Data to update
   * @returns {Promise<User>}
   */
  async update(userId, updateData) {
    try {
      const allowedFields = ['person_name', 'username'];
      const updates = [];
      const values = [];
      let paramIndex = 1;

      // Build dynamic update query
      for (const [key, value] of Object.entries(updateData)) {
        const dbKey = key === 'personName' ? 'person_name' : key;
        
        if (allowedFields.includes(dbKey) && value !== undefined && value !== null) {
          updates.push(`${dbKey} = $${paramIndex}`);
          values.push(value);
          paramIndex++;
        }
      }

      if (updates.length === 0) {
        throw new Error('No valid fields to update');
      }

      values.push(userId);

      const query = `
        UPDATE person 
        SET ${updates.join(', ')}
        WHERE person_id = $${paramIndex}
        RETURNING person_id, person_name, username, role, manager_person_id, member_of_organization_id, is_admin
      `;

      const result = await pool.query(query, values);

      if (result.rows.length === 0) {
        throw new Error('User not found');
      }

      return new User(result.rows[0]);
    } catch (error) {
      console.error('Error updating user:', error);
      throw error;
    }
  }

  /**
   * Get all users (for managers/admins)
   * @returns {Promise<User[]>}
   */
  async findAll() {
    try {
      const result = await pool.query(
        'SELECT person_id, person_name, username, role, manager_person_id, member_of_organization_id, is_admin FROM person ORDER BY person_id'
      );

      return result.rows.map(row => new User(row));
    } catch (error) {
      console.error('Error finding all users:', error);
      throw error;
    }
  }
}

module.exports = new UserRepository();


