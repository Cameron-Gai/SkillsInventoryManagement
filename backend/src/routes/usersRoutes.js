const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');
const { ensureTeamHighValueSkillsTable } = require('../utils/highValueSkillsTable');
const { computeCompanyFocusSkills } = require('../utils/companyFocus');

const router = express.Router();

// Get current user profile
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

    const summaryResult = await db.query(
      `SELECT status, COUNT(*)::int as count
       FROM person_skill
       WHERE person_id = $1
       GROUP BY status`,
      [userId]
    );

    const userSkillsResult = await db.query(
      `SELECT skill_id, status
       FROM person_skill
       WHERE person_id = $1`,
      [userId]
    );

    const userSkillStatusMap = new Map(
      userSkillsResult.rows.map((row) => [row.skill_id, row.status?.toLowerCase?.()])
    );

    const summary = summaryResult.rows.reduce(
      (acc, row) => {
        const key = row.status?.toLowerCase?.();
        if (key === 'approved') acc.approved = row.count;
        else if (key === 'requested') acc.pending = row.count;
        else if (key === 'canceled') acc.canceled = row.count;
        acc.total += row.count;
        return acc;
      },
      { approved: 0, pending: 0, canceled: 0, total: 0 }
    );

    const skillDetailResult = await db.query(
      `SELECT s.skill_name, s.skill_type, ps.status
       FROM person_skill ps
       JOIN skill s ON s.skill_id = ps.skill_id
       WHERE ps.person_id = $1
       ORDER BY ps.status DESC, s.skill_name ASC
       LIMIT 6`,
      [userId]
    );

    const recommendedMatches = skillDetailResult.rows.map((row, index) => ({
      name: row.skill_name,
      role: row.skill_type,
      status: row.status?.toLowerCase?.() === 'requested' ? 'pending' : 'approved',
      match: Math.min(95, 60 + index * 5),
      tags: [row.skill_type, row.status],
    }));

    const matchScore = summary.total > 0 ? Math.round((summary.approved / summary.total) * 100) : 0;

    const directReportResult = await db.query(
      'SELECT COUNT(*)::int AS report_count FROM person WHERE manager_person_id = $1',
      [userId]
    );
    const directReportCount = Number(directReportResult.rows[0]?.report_count || 0);
    const hasDirectReports = directReportCount > 0;

    const buildSuggestedSkillPayload = (row) => {
      const status = userSkillStatusMap.get(row.skill_id);
      const normalizedStatus = status?.toLowerCase?.();
      const satisfied = normalizedStatus === 'approved';
      const requested = normalizedStatus === 'requested';
      const statusLabel = satisfied ? 'satisfied' : requested ? 'requested' : 'not_started';

      const payload = {
        skill_id: row.skill_id,
        name: row.skill_name,
        type: row.skill_type,
        priority: row.priority,
        notes: row.notes || '',
        already_requested: requested,
        status: statusLabel,
        satisfied,
      };

      const optionalNumber = (value) => {
        if (value === null || value === undefined) return null;
        const parsed = Number(value);
        return Number.isFinite(parsed) ? parsed : null;
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

    let suggestedSkills = [];

    if (user.manager_person_id) {
      await ensureTeamHighValueSkillsTable();
      const desiredResult = await db.query(
        `SELECT t.skill_id, t.priority, t.notes, s.skill_name, s.skill_type
         FROM team_high_value_skills t
         JOIN skill s ON s.skill_id = t.skill_id
         WHERE t.team_id = $1`,
        [user.manager_person_id]
      );

      const teamSuggested = desiredResult.rows.map((row) => buildSuggestedSkillPayload(row));

      suggestedSkills = teamSuggested;
    }

    const scopedOrgId = user.is_admin ? null : user.member_of_organization_id || null;
    const companyFocusSkills = await computeCompanyFocusSkills(8, {
      organizationId: scopedOrgId,
    });
    const companySuggested = companyFocusSkills.map((row) => buildSuggestedSkillPayload(row));

    const suggestedSkillsPayload = {
      team: Array.isArray(suggestedSkills) ? suggestedSkills : [],
      company: companySuggested,
    };

    res.json({
      person_id: user.person_id,
      name: user.person_name,
      username: user.username,
      role: user.role || (user.is_admin ? 'admin' : 'employee'),
      is_admin: user.is_admin,
      manager_id: user.manager_person_id,
      organization_id: user.member_of_organization_id,
      skill_summary: summary,
      match_score: matchScore,
      recommended_matches: recommendedMatches,
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
      `SELECT
         p.person_id,
         p.person_name,
         p.username,
         p.is_admin,
         p.manager_person_id,
         p.member_of_organization_id,
         p.role,
         COALESCE(stats.total_skills, 0) AS skills_count,
         COALESCE(stats.pending_skills, 0) AS pending_skills_count,
         COALESCE(stats.approved_skills, 0) AS approved_skills_count,
         COALESCE(stats.pending_skill_names, '[]') AS pending_skill_names
       FROM person p
       LEFT JOIN (
         SELECT
           ps.person_id,
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS total_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Requested') AS pending_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS approved_skills,
           json_agg(
             json_build_object(
               'skill_id', s.skill_id,
               'name', s.skill_name,
               'type', s.skill_type,
               'requested_at', ps.requested_at,
               'usage_frequency', ps.usage_frequency,
               'experience_years', ps.experience_years,
               'proficiency_level', ps.proficiency_level,
               'notes', COALESCE(ps.notes, '')
             )
           )
             FILTER (WHERE ps.status = 'Requested') AS pending_skill_names
         FROM person_skill ps
         JOIN skill s ON s.skill_id = ps.skill_id
         GROUP BY ps.person_id
       ) stats ON stats.person_id = p.person_id
       ORDER BY p.person_name`
    );

    const users = result.rows.map(user => {
      let pendingSkillNames = [];
      if (Array.isArray(user.pending_skill_names)) {
        pendingSkillNames = user.pending_skill_names;
      } else if (user.pending_skill_names) {
        try {
          pendingSkillNames = JSON.parse(user.pending_skill_names);
        } catch (_) {
          pendingSkillNames = [];
        }
      }

      return {
        person_id: user.person_id,
        name: user.person_name,
        username: user.username,
        role: user.role || (user.is_admin ? 'admin' : 'employee'),
        is_admin: user.is_admin,
        manager_id: user.manager_person_id,
        organization_id: user.member_of_organization_id,
        skills_count: Number(user.skills_count) || 0,
        pending_skills_count: Number(user.pending_skills_count) || 0,
        approved_skills_count: Number(user.approved_skills_count) || 0,
        pending_skills: pendingSkillNames,
      };
    });

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
