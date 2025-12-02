const express = require('express');
const router = express.Router();
const skillApprovalController = require('../controllers/SkillApprovalController');

/**
 * Approval Routes
 * Endpoints for manager approval workflow
 * Base path: /api/approvals
 */

// GET /api/approvals/pending - Get all pending skill submissions
router.get('/pending', skillApprovalController.getPendingApprovals.bind(skillApprovalController));

// GET /api/approvals/statistics - Get approval statistics
router.get('/statistics', skillApprovalController.getApprovalStatistics.bind(skillApprovalController));

// GET /api/approvals/:skillStatusId/history - Get approval history for a skill
router.get('/:skillStatusId/history', skillApprovalController.getApprovalHistory.bind(skillApprovalController));

// POST /api/approvals/:skillStatusId/approve - Approve a skill submission
router.post('/:skillStatusId/approve', skillApprovalController.approveSkill.bind(skillApprovalController));

// POST /api/approvals/:skillStatusId/reject - Reject a skill submission
router.post('/:skillStatusId/reject', skillApprovalController.rejectSkill.bind(skillApprovalController));

// POST /api/approvals/batch/approve - Batch approve multiple submissions
router.post('/batch/approve', skillApprovalController.batchApproveSkills.bind(skillApprovalController));

module.exports = router;
