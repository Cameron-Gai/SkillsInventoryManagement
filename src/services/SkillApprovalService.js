const skillRepository = require('../repositories/SkillRepository');
const auditRepository = require('../repositories/AuditRepository');

/**
 * SkillApprovalService
 * Business logic for manager approval workflow
 * Implements FR-03, FR-05: Approval for new/edited skills with manager validation
 */
class SkillApprovalService {
  /**
   * Get all pending skill submissions awaiting approval
   * Used by managers to view submissions requiring their approval
   */
  async getPendingApprovals() {
    try {
      const pendingSkills = await skillRepository.getPendingSkillStatuses();
      return {
        success: true,
        data: pendingSkills,
        count: pendingSkills.length
      };
    } catch (error) {
      console.error('Error fetching pending approvals:', error);
      throw new Error('Failed to retrieve pending approvals');
    }
  }

  /**
   * Approve a skill submission
   * @param {number} skillStatusId - The ID of the skill status to approve
   * @param {number} managerId - The ID of the manager approving
   * @param {string} reason - Optional reason for approval
   * @param {string} ipAddress - IP address of the approving manager
   */
  async approveSkill(skillStatusId, managerId, reason = null, ipAddress = null) {
    try {
      // Get current skill status before update
      const currentSkillStatus = await skillRepository.getSkillStatusById(skillStatusId);
      
      if (!currentSkillStatus) {
        return {
          success: false,
          error: 'Skill submission not found'
        };
      }

      if (currentSkillStatus.approvalStatus !== 'PENDING') {
        return {
          success: false,
          error: `Skill submission is already ${currentSkillStatus.approvalStatus.toLowerCase()}`
        };
      }

      // Update skill status to APPROVED
      const updatedSkillStatus = await skillRepository.updateSkillStatusApproval(
        skillStatusId,
        'APPROVED',
        managerId
      );

      // Update the skill itself to APPROVED status
      await skillRepository.updateSkillStatus(currentSkillStatus.skillId, 'APPROVED');

      // Log the approval action in audit log
      await auditRepository.createAuditLog({
        action: 'APPROVE',
        userId: managerId,
        targetType: 'SKILL_STATUS',
        targetId: skillStatusId,
        oldValue: { approvalStatus: 'PENDING' },
        newValue: { approvalStatus: 'APPROVED', approvedBy: managerId },
        reason: reason || 'Skill approved by manager',
        timestamp: new Date(),
        ipAddress: ipAddress
      });

      return {
        success: true,
        message: 'Skill approved successfully',
        data: updatedSkillStatus
      };
    } catch (error) {
      console.error('Error approving skill:', error);
      throw new Error('Failed to approve skill');
    }
  }

  /**
   * Reject a skill submission
   * @param {number} skillStatusId - The ID of the skill status to reject
   * @param {number} managerId - The ID of the manager rejecting
   * @param {string} reason - Reason for rejection (required)
   * @param {string} ipAddress - IP address of the rejecting manager
   */
  async rejectSkill(skillStatusId, managerId, reason, ipAddress = null) {
    try {
      if (!reason || reason.trim() === '') {
        return {
          success: false,
          error: 'Reason is required for rejection'
        };
      }

      // Get current skill status before update
      const currentSkillStatus = await skillRepository.getSkillStatusById(skillStatusId);
      
      if (!currentSkillStatus) {
        return {
          success: false,
          error: 'Skill submission not found'
        };
      }

      if (currentSkillStatus.approvalStatus !== 'PENDING') {
        return {
          success: false,
          error: `Skill submission is already ${currentSkillStatus.approvalStatus.toLowerCase()}`
        };
      }

      // Update skill status to REJECTED
      const updatedSkillStatus = await skillRepository.updateSkillStatusApproval(
        skillStatusId,
        'REJECTED',
        managerId
      );

      // Update the skill itself to REJECTED status
      await skillRepository.updateSkillStatus(currentSkillStatus.skillId, 'REJECTED');

      // Log the rejection action in audit log
      await auditRepository.createAuditLog({
        action: 'REJECT',
        userId: managerId,
        targetType: 'SKILL_STATUS',
        targetId: skillStatusId,
        oldValue: { approvalStatus: 'PENDING' },
        newValue: { approvalStatus: 'REJECTED', approvedBy: managerId },
        reason: reason,
        timestamp: new Date(),
        ipAddress: ipAddress
      });

      return {
        success: true,
        message: 'Skill rejected successfully',
        data: updatedSkillStatus
      };
    } catch (error) {
      console.error('Error rejecting skill:', error);
      throw new Error('Failed to reject skill');
    }
  }

  /**
   * Batch approve multiple skill submissions
   * @param {Array<number>} skillStatusIds - Array of skill status IDs to approve
   * @param {number} managerId - The ID of the manager approving
   * @param {string} ipAddress - IP address of the approving manager
   */
  async batchApproveSkills(skillStatusIds, managerId, ipAddress = null) {
    const results = {
      success: [],
      failed: []
    };

    for (const skillStatusId of skillStatusIds) {
      try {
        const result = await this.approveSkill(skillStatusId, managerId, 'Batch approval', ipAddress);
        if (result.success) {
          results.success.push({ skillStatusId, ...result });
        } else {
          results.failed.push({ skillStatusId, error: result.error });
        }
      } catch (error) {
        results.failed.push({ skillStatusId, error: error.message });
      }
    }

    return {
      success: true,
      summary: {
        total: skillStatusIds.length,
        approved: results.success.length,
        failed: results.failed.length
      },
      results: results
    };
  }

  /**
   * Get approval history for a specific skill status
   * @param {number} skillStatusId - The ID of the skill status
   */
  async getApprovalHistory(skillStatusId) {
    try {
      const auditLogs = await auditRepository.getAuditLogsByTarget('SKILL_STATUS', skillStatusId);
      return {
        success: true,
        data: auditLogs
      };
    } catch (error) {
      console.error('Error fetching approval history:', error);
      throw new Error('Failed to retrieve approval history');
    }
  }

  /**
   * Get approval statistics for a manager's dashboard
   * @param {number} managerId - Optional: filter by specific manager
   */
  async getApprovalStatistics(managerId = null) {
    try {
      const approvals = await auditRepository.getAuditLogsByAction('APPROVE', 100);
      const rejections = await auditRepository.getAuditLogsByAction('REJECT', 100);
      
      const stats = {
        totalApprovals: approvals.length,
        totalRejections: rejections.length,
        recentApprovals: approvals.slice(0, 10),
        recentRejections: rejections.slice(0, 10)
      };

      if (managerId) {
        stats.managerApprovals = approvals.filter(a => a.userId === managerId).length;
        stats.managerRejections = rejections.filter(r => r.userId === managerId).length;
      }

      return {
        success: true,
        data: stats
      };
    } catch (error) {
      console.error('Error fetching approval statistics:', error);
      throw new Error('Failed to retrieve approval statistics');
    }
  }
}

module.exports = new SkillApprovalService();
