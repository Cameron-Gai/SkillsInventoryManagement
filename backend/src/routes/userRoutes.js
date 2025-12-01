// userRoutes.js
// API route definitions for user endpoints

const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// TODO: Add authentication middleware
// For now, we'll use a simple mock middleware that extracts user from token
// In production, you'll want to use a proper JWT verification middleware

/**
 * Mock authentication middleware
 * TODO: Replace with proper JWT verification
 * This extracts user ID from the Authorization header token
 */
const mockAuthMiddleware = (req, res, next) => {
  // Extract token from Authorization header
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      error: 'Unauthorized',
      message: 'No token provided'
    });
  }

  const token = authHeader.substring(7);

  // TODO: Verify JWT token and extract user info
  // For now, we'll use a simple mock
  // In production, decode and verify the JWT token here
  
  // Mock: Assume token contains user ID (this is temporary!)
  // You should decode the JWT and verify it properly
  try {
    // This is a placeholder - replace with actual JWT verification
    // For now, we'll try to parse it as JSON or use a default
    let userId;
    try {
      // If token is a simple number string, use it
      userId = parseInt(token);
      if (isNaN(userId)) {
        // If not a number, try to decode as base64 JSON (temporary workaround)
        const decoded = Buffer.from(token, 'base64').toString('utf-8');
        const parsed = JSON.parse(decoded);
        userId = parsed.userId || parsed.id || 1;
      }
    } catch {
      // Default to user ID 1 for testing
      userId = 1;
    }

    // Attach user info to request
    req.user = {
      id: userId,
      // Add other user properties from token when you implement JWT
    };

    next();
  } catch (error) {
    return res.status(401).json({
      error: 'Unauthorized',
      message: 'Invalid token'
    });
  }
};

// Apply authentication middleware to all routes
router.use(mockAuthMiddleware);

// Employee profile routes
router.get('/me', userController.getMyProfile.bind(userController));
router.put('/me', userController.updateMyProfile.bind(userController));

// Manager/Admin routes (get all users)
router.get('/', userController.getAllUsers.bind(userController));

module.exports = router;


