const skillApprovalService = require('../services/SkillApprovalService');

/**
 * SkillApprovalController
 * Handles HTTP requests for skill approval workflow
 * Endpoints for managers to approve/reject employee skill submissions
 */
class SkillApprovalController {
  /**
   * GET /api/approvals/pending
   * Get all pending skill submissions awaiting approval
   */
  async getPendingApprovals(req, res) {
    try {
      const result = await skillApprovalService.getPendingApprovals();
      
      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data,
          count: result.count,
          message: `Found ${result.count} pending approval(s)`
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in getPendingApprovals:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/approvals/:skillStatusId/approve
   * Approve a specific skill submission
   */
  async approveSkill(req, res) {
    try {
      const { skillStatusId } = req.params;
      const { managerId, reason } = req.body;
      const ipAddress = req.ip || req.connection.remoteAddress;

      // Validate required fields
      if (!managerId) {
        return res.status(400).json({
          success: false,
          error: 'Manager ID is required'
        });
      }

      const result = await skillApprovalService.approveSkill(
        parseInt(skillStatusId),
        managerId,
        reason,
        ipAddress
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          message: result.message,
          data: result.data
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in approveSkill:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/approvals/:skillStatusId/reject
   * Reject a specific skill submission
   */
  async rejectSkill(req, res) {
    try {
      const { skillStatusId } = req.params;
      const { managerId, reason } = req.body;
      const ipAddress = req.ip || req.connection.remoteAddress;

      // Validate required fields
      if (!managerId) {
        return res.status(400).json({
          success: false,
          error: 'Manager ID is required'
        });
      }

      if (!reason || reason.trim() === '') {
        return res.status(400).json({
          success: false,
          error: 'Reason is required for rejection'
        });
      }

      const result = await skillApprovalService.rejectSkill(
        parseInt(skillStatusId),
        managerId,
        reason,
        ipAddress
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          message: result.message,
          data: result.data
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in rejectSkill:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * POST /api/approvals/batch/approve
   * Batch approve multiple skill submissions
   */
  async batchApproveSkills(req, res) {
    try {
      const { skillStatusIds, managerId } = req.body;
      const ipAddress = req.ip || req.connection.remoteAddress;

      // Validate required fields
      if (!managerId) {
        return res.status(400).json({
          success: false,
          error: 'Manager ID is required'
        });
      }

      if (!skillStatusIds || !Array.isArray(skillStatusIds) || skillStatusIds.length === 0) {
        return res.status(400).json({
          success: false,
          error: 'Array of skill status IDs is required'
        });
      }

      const result = await skillApprovalService.batchApproveSkills(
        skillStatusIds,
        managerId,
        ipAddress
      );

      res.status(200).json({
        success: true,
        message: `Batch approval completed: ${result.summary.approved} approved, ${result.summary.failed} failed`,
        summary: result.summary,
        results: result.results
      });
    } catch (error) {
      console.error('Error in batchApproveSkills:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * GET /api/approvals/:skillStatusId/history
   * Get approval history for a specific skill submission
   */
  async getApprovalHistory(req, res) {
    try {
      const { skillStatusId } = req.params;

      const result = await skillApprovalService.getApprovalHistory(parseInt(skillStatusId));

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data,
          count: result.data.length
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in getApprovalHistory:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }

  /**
   * GET /api/approvals/statistics
   * Get approval statistics for manager dashboard
   */
  async getApprovalStatistics(req, res) {
    try {
      const { managerId } = req.query;

      const result = await skillApprovalService.getApprovalStatistics(
        managerId ? parseInt(managerId) : null
      );

      if (result.success) {
        res.status(200).json({
          success: true,
          data: result.data
        });
      } else {
        res.status(400).json({
          success: false,
          error: result.error
        });
      }
    } catch (error) {
      console.error('Error in getApprovalStatistics:', error);
      res.status(500).json({
        success: false,
        error: 'Internal server error',
        message: error.message
      });
    }
  }
}

module.exports = new SkillApprovalController();
