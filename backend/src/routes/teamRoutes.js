const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');
const { ensureTeamHighValueSkillsTable } = require('../utils/highValueSkillsTable');

const formatHighValueSkill = (record) => ({
  id: record.id,
  team_id: record.team_id,
  skill_id: record.skill_id,
  skill_name: record.skill_name,
  skill_type: record.skill_type,
  priority: record.priority,
  notes: record.notes || '',
  created_at: record.created_at,
});

const router = express.Router();

// Get team members for the current manager
router.get('/my-team', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;

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
         COALESCE(stats.pending_skills, 0) AS pending_skills,
         COALESCE(stats.approved_skills, 0) AS approved_skills,
         COALESCE(stats.top_skills, '[]') AS top_skills,
         COALESCE(stats.pending_skill_details, '[]') AS pending_skill_details
       FROM person p
       LEFT JOIN (
         SELECT
           ps.person_id,
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS total_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Pending') AS pending_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS approved_skills,
           json_agg(DISTINCT s.skill_name ORDER BY s.skill_name)
             FILTER (WHERE s.skill_name IS NOT NULL AND ps.status = 'Approved') AS top_skills,
           json_agg(
             json_build_object(
               'skill_id', s.skill_id,
               'name', s.skill_name,
               'type', s.skill_type,
               'requested_at', ps.requested_at,
               'proficiency_level', ps.proficiency_level,
               'usage_frequency', ps.usage_frequency,
               'experience_years', ps.experience_years,
               'notes', COALESCE(ps.notes, '')
             )
           ) FILTER (WHERE ps.status = 'Pending') AS pending_skill_details
         FROM person_skill ps
         JOIN skill s ON s.skill_id = ps.skill_id
         GROUP BY ps.person_id
       ) stats ON stats.person_id = p.person_id
       WHERE p.manager_person_id = $1
       ORDER BY p.person_name`,
      [managerId]
    );

    const teamMembers = result.rows.map(member => {
      let topSkills = [];
      let pendingSkillDetails = [];
      if (Array.isArray(member.top_skills)) {
        topSkills = member.top_skills;
      } else if (member.top_skills) {
        try {
          topSkills = JSON.parse(member.top_skills);
        } catch (_) {
          topSkills = [];
        }
      }

      if (Array.isArray(member.pending_skill_details)) {
        pendingSkillDetails = member.pending_skill_details;
      } else if (member.pending_skill_details) {
        try {
          pendingSkillDetails = JSON.parse(member.pending_skill_details);
        } catch (_) {
          pendingSkillDetails = [];
        }
      }

      return {
        person_id: member.person_id,
        name: member.person_name,
        username: member.username,
        role: member.role || 'employee',
        is_admin: member.is_admin,
        manager_id: member.manager_person_id,
        organization_id: member.member_of_organization_id,
        skills_count: Number(member.skills_count) || 0,
        pending_skills: Number(member.pending_skills) || 0,
        approved_skills: Number(member.approved_skills) || 0,
        top_skills: topSkills,
        pending_skills_detail: pendingSkillDetails,
      };
    });

    res.json(teamMembers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/high-value-skills', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    await ensureTeamHighValueSkillsTable();
    const managerId = req.user.person_id;

    const result = await db.query(
      `SELECT t.id, t.team_id, t.skill_id, t.priority, t.notes, t.created_at, s.skill_name, s.skill_type
       FROM team_high_value_skills t
       JOIN skill s ON s.skill_id = t.skill_id
       WHERE t.team_id = $1
       ORDER BY t.created_at DESC`,
      [managerId]
    );

    res.json(result.rows.map(formatHighValueSkill));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/high-value-skills', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    await ensureTeamHighValueSkillsTable();
    const managerId = req.user.person_id;
    const { skill_id, priority = 'High', notes = '' } = req.body;

    if (!skill_id) {
      return res.status(400).json({ error: 'skill_id is required' });
    }

    const insertResult = await db.query(
      `INSERT INTO team_high_value_skills (team_id, skill_id, priority, notes, assigned_by)
       VALUES ($1, $2, $3, $4, $5)
       ON CONFLICT (team_id, skill_id)
       DO UPDATE SET priority = EXCLUDED.priority, notes = EXCLUDED.notes
       RETURNING id`,
      [managerId, skill_id, priority, notes, managerId]
    );

    const recordId = insertResult.rows[0].id;

    const detailResult = await db.query(
      `SELECT t.id, t.team_id, t.skill_id, t.priority, t.notes, t.created_at, s.skill_name, s.skill_type
       FROM team_high_value_skills t
       JOIN skill s ON s.skill_id = t.skill_id
       WHERE t.id = $1 AND t.team_id = $2`,
      [recordId, managerId]
    );

    res.status(201).json(formatHighValueSkill(detailResult.rows[0]));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.delete('/high-value-skills/:id', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    await ensureTeamHighValueSkillsTable();
    const managerId = req.user.person_id;
    const { id } = req.params;

    const result = await db.query(
      'DELETE FROM team_high_value_skills WHERE id = $1 AND team_id = $2 RETURNING id',
      [id, managerId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'High-value skill not found' });
    }

    res.json({ message: 'High-value skill removed', id: Number(id) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get a specific team member's details with skills
router.get('/my-team/:memberId', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;
    const { memberId } = req.params;

    // Verify the member belongs to this manager's team
    const memberCheck = await db.query(
      'SELECT person_id, person_name, username, is_admin, manager_person_id, role FROM person WHERE person_id = $1 AND manager_person_id = $2',
      [memberId, managerId]
    );

    if (memberCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Team member not found' });
    }

    const member = memberCheck.rows[0];

    // Get skills for this member
    const skillsResult = await db.query(
      `SELECT ps.skill_id, ps.status, s.skill_name, s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1
       ORDER BY s.skill_name`,
      [memberId]
    );

    const skills = skillsResult.rows.map(skill => ({
      id: skill.skill_id,
      name: skill.skill_name,
      type: skill.skill_type,
      status: skill.status,
    }));

    res.json({
      person_id: member.person_id,
      name: member.person_name,
      username: member.username,
      is_admin: member.is_admin,
      role: member.role || 'employee',
      manager_id: member.manager_person_id,
      skills,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get team insights (skill distribution, pending approvals, etc.)
router.get('/insights', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;

    const [teamCountResult, pendingResult, skillDistResult, skillStatsResult, projectResult, pendingByTypeResult, spotlightResult] = await Promise.all([
      db.query('SELECT COUNT(*) AS team_size FROM person WHERE manager_person_id = $1', [managerId]),
      db.query(
        `SELECT COUNT(*) AS pending_count
         FROM person_skill ps
         JOIN person p ON ps.person_id = p.person_id
         WHERE p.manager_person_id = $1 AND ps.status = 'Pending'`,
        [managerId]
      ),
      db.query(
        `SELECT s.skill_name, COUNT(*) AS user_count
         FROM person_skill ps
         JOIN person p ON ps.person_id = p.person_id
         JOIN skill s ON ps.skill_id = s.skill_id
         WHERE p.manager_person_id = $1 AND ps.status = 'Approved'
         GROUP BY s.skill_name
         ORDER BY user_count DESC
         LIMIT 10`,
        [managerId]
      ),
      db.query(
        `SELECT
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS approved_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Pending') AS pending_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Canceled') AS canceled_skills,
           COUNT(DISTINCT ps.skill_id) FILTER (WHERE ps.status = 'Approved') AS unique_skills,
           COUNT(*) FILTER (WHERE ps.status = 'Approved') AS team_skill_count
         FROM person_skill ps
         JOIN person p ON p.person_id = ps.person_id
         WHERE p.manager_person_id = $1`,
        [managerId]
      ),
      db.query(
        `SELECT COUNT(DISTINCT ppa.project_id) AS active_projects
         FROM person_project_assignment ppa
         JOIN person p ON p.person_id = ppa.person_id
         WHERE p.manager_person_id = $1`,
        [managerId]
      ),
      db.query(
        `SELECT s.skill_type, COUNT(*) AS count
         FROM person_skill ps
         JOIN person p ON ps.person_id = p.person_id
         JOIN skill s ON s.skill_id = ps.skill_id
         WHERE p.manager_person_id = $1 AND ps.status = 'Pending'
         GROUP BY s.skill_type`,
        [managerId]
      ),
      db.query(
        `SELECT p.person_name, s.skill_name, s.skill_type, ps.status
         FROM person_skill ps
         JOIN person p ON p.person_id = ps.person_id
         JOIN skill s ON s.skill_id = ps.skill_id
         WHERE p.manager_person_id = $1
         ORDER BY (ps.status = 'Pending') DESC, s.skill_name
         LIMIT 4`,
        [managerId]
      ),
    ]);

    const skillStats = skillStatsResult.rows[0] || {};
    const approvalBreakdown = pendingByTypeResult.rows.reduce((acc, row) => {
      const type = row.skill_type || 'Other';
      const count = parseInt(row.count);
      if (['Technology'].includes(type)) acc.high += count;
      else if (['Experience', 'Knowledge'].includes(type)) acc.medium += count;
      else acc.low += count;
      return acc;
    }, { high: 0, medium: 0, low: 0 });

    const spotlight = spotlightResult.rows.map((row, index) => ({
      name: row.person_name,
      role: row.skill_type,
      status: ['pending', 'requested'].includes(row.status?.toLowerCase?.()) ? 'pending' : row.status,
      match: Math.min(95, 65 + index * 5),
      tags: [row.skill_name, row.skill_type],
    }));

    res.json({
      team_size: parseInt(teamCountResult.rows[0].team_size),
      pending_approvals: parseInt(pendingResult.rows[0].pending_count),
      top_skills: skillDistResult.rows.map(row => ({
        skill_name: row.skill_name,
        user_count: parseInt(row.user_count),
      })),
      unique_skills: parseInt(skillStats.unique_skills || 0),
      team_skill_count: parseInt(skillStats.team_skill_count || 0),
      approved_skills: parseInt(skillStats.approved_skills || 0),
      pending_skills: parseInt(skillStats.pending_skills || 0),
      canceled_skills: parseInt(skillStats.canceled_skills || 0),
      active_projects: parseInt(projectResult.rows[0]?.active_projects || 0),
      recent_updates: parseInt(skillStats.pending_skills || 0) + parseInt(skillStats.canceled_skills || 0),
      approval_breakdown: approvalBreakdown,
      spotlight_matches: spotlight,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Approve a skill for a team member
router.patch('/my-team/:memberId/skills/:skillId/approve', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;
    const { memberId, skillId } = req.params;

    // Verify the member belongs to this manager's team
    const memberCheck = await db.query(
      'SELECT person_id FROM person WHERE person_id = $1 AND manager_person_id = $2',
      [memberId, managerId]
    );

    if (memberCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Team member not found' });
    }

    const result = await db.query(
      'UPDATE person_skill SET status = $1 WHERE person_id = $2 AND skill_id = $3 RETURNING person_id, skill_id, status',
      ['Approved', memberId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for team member' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Reject a skill for a team member
router.patch('/my-team/:memberId/skills/:skillId/reject', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;
    const { memberId, skillId } = req.params;

    // Verify the member belongs to this manager's team
    const memberCheck = await db.query(
      'SELECT person_id FROM person WHERE person_id = $1 AND manager_person_id = $2',
      [memberId, managerId]
    );

    if (memberCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Team member not found' });
    }

    const result = await db.query(
      'UPDATE person_skill SET status = $1 WHERE person_id = $2 AND skill_id = $3 RETURNING person_id, skill_id, status',
      ['Canceled', memberId, skillId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Skill not found for team member' });
    }

    res.json({
      person_id: result.rows[0].person_id,
      skill_id: result.rows[0].skill_id,
      status: result.rows[0].status,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
