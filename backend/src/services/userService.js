// userService.js
// Business logic layer for user operations
// Handles validation, business rules, and orchestrates repository calls

const userRepository = require('../repositories/userRepository');

class UserService {
  /**
   * Get user profile by ID
   * @param {number} userId - User ID
   * @returns {Promise<Object>}
   */
  async getProfile(userId) {
    if (!userId) {
      throw new Error('User ID is required');
    }

    const user = await userRepository.findById(userId);

    if (!user) {
      throw new Error('User not found');
    }

    return user.toDatabaseFormat();
  }

  /**
   * Update user profile
   * @param {number} userId - Person ID
   * @param {Object} updateData - Data to update
   * @returns {Promise<Object>}
   */
  async updateProfile(userId, updateData) {
    if (!userId) {
      throw new Error('User ID is required');
    }

    // Validate update data
    const allowedFields = ['personName', 'username'];
    const filteredData = {};

    for (const [key, value] of Object.entries(updateData)) {
      if (allowedFields.includes(key) && value !== undefined && value !== null) {
        // Basic validation
        if (typeof value === 'string' && value.trim().length === 0) {
          throw new Error(`${key} cannot be empty`);
        }
        filteredData[key] = value.trim ? value.trim() : value;
      }
    }

    if (Object.keys(filteredData).length === 0) {
      throw new Error('No valid fields provided for update');
    }

    // Username validation (if provided)
    if (filteredData.username) {
      // Username should be lowercase and contain only alphanumeric, dots, underscores, hyphens
      if (!/^[a-z0-9._-]+$/.test(filteredData.username)) {
        throw new Error('Invalid username format. Username must be lowercase and contain only letters, numbers, dots, underscores, or hyphens');
      }
    }

    // Person name validation (if provided)
    if (filteredData.personName && filteredData.personName.length > 255) {
      throw new Error('Person name cannot exceed 255 characters');
    }

    const updatedUser = await userRepository.update(userId, filteredData);

    return updatedUser.toDatabaseFormat();
  }

  /**
   * Get all users (for managers/admins)
   * @returns {Promise<Object[]>}
   */
  async getAllUsers() {
    const users = await userRepository.findAll();
    return users.map(user => user.toDatabaseFormat());
  }
}

module.exports = new UserService();


