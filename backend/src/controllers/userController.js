// userController.js
// Request/response handling for user endpoints
// Extracts data from requests, calls services, formats responses

const userService = require('../services/userService');

class UserController {
  /**
   * Get current user's profile
   * GET /api/v1/users/me
   */
  async getMyProfile(req, res, next) {
    try {
      // Get user ID from authenticated request (set by auth middleware)
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'User not authenticated'
        });
      }

      const profile = await userService.getProfile(userId);

      res.status(200).json({
        success: true,
        data: profile
      });
    } catch (error) {
      next(error);
    }
  }

  /**
   * Update current user's profile
   * PUT /api/v1/users/me
   */
  async updateMyProfile(req, res, next) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'User not authenticated'
        });
      }

      const updateData = req.body;
      const updatedProfile = await userService.updateProfile(userId, updateData);

      res.status(200).json({
        success: true,
        message: 'Profile updated successfully',
        data: updatedProfile
      });
    } catch (error) {
      // Handle validation errors
      if (error.message.includes('cannot be empty') || 
          error.message.includes('Invalid') ||
          error.message.includes('No valid fields')) {
        return res.status(400).json({
          error: 'Validation Error',
          message: error.message
        });
      }

      if (error.message === 'User not found') {
        return res.status(404).json({
          error: 'Not Found',
          message: error.message
        });
      }

      next(error);
    }
  }

  /**
   * Get all users (for managers/admins)
   * GET /api/v1/users
   */
  async getAllUsers(req, res, next) {
    try {
      // TODO: Add role-based authorization check
      // For now, allow any authenticated user
      const users = await userService.getAllUsers();

      res.status(200).json({
        success: true,
        data: users,
        count: users.length
      });
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new UserController();


