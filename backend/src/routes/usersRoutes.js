const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');
const { ensureTeamHighValueSkillsTable } = require('../utils/highValueSkillsTable');
const { computeCompanyFocusSkills } = require('../utils/companyFocus');

const router = express.Router();

//get current user profile
router.get('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    
    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person WHERE person_id = $1',
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];

    // Get skill summary
    const skillSummaryResult = await db.query(
      `SELECT status, COUNT(*) as count
       FROM person_skill
       WHERE person_id = $1
       GROUP BY status`,
      [userId]
    );

    const summary = {};
    skillSummaryResult.rows.forEach(row => {
      summary[row.status] = parseInt(row.count);
    });
    summary.approved = summary.Approved || 0;
    summary.pending = summary.Requested || 0;
    summary.canceled = summary.Canceled || 0;
    summary.total = summary.approved + summary.pending + summary.canceled;

    // Get user's existing skills with status map
    const userSkillsResult = await db.query(
      'SELECT skill_id, status FROM person_skill WHERE person_id = $1',
      [userId]
    );
    const userSkillStatusMap = new Map();
    userSkillsResult.rows.forEach(row => {
      userSkillStatusMap.set(row.skill_id, row.status);
    });

    // Helper to build suggested skill payload
    const buildSuggestedSkillPayload = (row) => {
      const status = userSkillStatusMap.get(row.skill_id);
      const normalizedStatus = status?.toLowerCase?.();
      const satisfied = normalizedStatus === 'approved';
      const pending = normalizedStatus === 'pending' || normalizedStatus === 'requested';

      const payload = {
        skill_id: row.skill_id,
        name: row.skill_name,
        type: row.skill_type,
        priority: row.priority,
        satisfied,
        already_pending: pending,
      };

      if (row.notes) payload.notes = row.notes;

      // Add company focus metadata
      const optionalNumber = (val) => {
        const num = Number(val);
        return Number.isFinite(num) ? num : null;
      };

      const teamCount = optionalNumber(row.team_count);
      const teamCoverage = optionalNumber(row.team_coverage);
      const employeePenetration = optionalNumber(row.employee_penetration);
      const approvedEmployees = optionalNumber(row.approved_employees);

      if (teamCount !== null) payload.team_count = teamCount;
      if (teamCoverage !== null) payload.team_coverage = teamCoverage;
      if (employeePenetration !== null) payload.employee_penetration = employeePenetration;
      if (approvedEmployees !== null) payload.approved_employees = approvedEmployees;

      return payload;
    };

    // Get team priorities (if user has a manager)
    let teamSuggested = [];
    if (user.manager_person_id) {
      await ensureTeamHighValueSkillsTable();
      const desiredResult = await db.query(
        `SELECT t.skill_id, t.priority, t.notes, s.skill_name, s.skill_type
         FROM team_high_value_skills t
         JOIN skill s ON s.skill_id = t.skill_id
         WHERE t.team_id = $1
         ORDER BY 
           CASE t.priority 
             WHEN 'High' THEN 1 
             WHEN 'Medium' THEN 2 
             WHEN 'Low' THEN 3 
             ELSE 4 
           END,
           s.skill_name`,
        [user.manager_person_id]
      );

      teamSuggested = desiredResult.rows.map((row) => buildSuggestedSkillPayload(row));
    }

    // Get company priorities (organization-level)
    const scopedOrgId = user.is_admin ? null : user.member_of_organization_id || null;
    const companyFocusSkills = await computeCompanyFocusSkills(8, {
      organizationId: scopedOrgId,
    });
    const companySuggested = companyFocusSkills.map((row) => buildSuggestedSkillPayload(row));

    const suggestedSkillsPayload = {
      team: Array.isArray(teamSuggested) ? teamSuggested : [],
      company: companySuggested,
    };

    // Get direct reports info
    const directReportResult = await db.query(
      'SELECT COUNT(*)::int AS report_count FROM person WHERE manager_person_id = $1',
      [userId]
    );
    const directReportCount = Number(directReportResult.rows[0]?.report_count || 0);
    const hasDirectReports = directReportCount > 0;

    res.json({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
      skill_summary: summary,
      suggested_skills: suggestedSkillsPayload,
      has_direct_reports: hasDirectReports,
      direct_report_count: directReportCount,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update user profile
router.put('/me', authenticate, async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { person_name } = req.body;

    if (!person_name) {
      return res.status(400).json({ error: 'person_name is required' });
    }

    const result = await db.query(
      'UPDATE person SET person_name = $1 WHERE person_id = $2 RETURNING person_id, person_name, is_admin',
      [person_name, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      name: result.rows[0].person_name,
      is_admin: result.rows[0].is_admin,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all users (admin/manager only)
router.get('/', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person ORDER BY person_name'
    );

    const users = result.rows.map(user => ({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
    }));

    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get a specific user by ID (admin/manager only)
router.get('/:id', authenticate, authorizeRoles('admin', 'manager'), async (req, res) => {
  try {
    const { id } = req.params;

    const result = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role FROM person WHERE person_id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];
    res.json({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete user (admin only)
router.delete('/:id', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    // Prevent deleting yourself
    if (req.user.person_id === parseInt(id)) {
      return res.status(400).json({ error: 'Cannot delete your own account' });
    }

    const result = await db.query(
      'DELETE FROM person WHERE person_id = $1 RETURNING person_id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ message: 'User deleted successfully', person_id: id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
