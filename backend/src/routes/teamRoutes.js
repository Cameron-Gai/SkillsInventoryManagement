const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');
const { ensureTeamHighValueSkillsTable } = require('../utils/highValueSkillsTable');

const router = express.Router();
// Admin: list all skill requests across the org with pagination
router.get('/admin/requests', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { page = 1, pageSize = 20, status } = req.query;
    const offset = (Number(page) - 1) * Number(pageSize);

    const params = [];
    let where = '';
    if (status && ['Requested', 'Approved', 'Canceled'].includes(status)) {
      params.push(status);
      where = 'WHERE ps.status = $1';
    }

    const totalResult = await db.query(
      `SELECT COUNT(*) AS total
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       JOIN skill s ON ps.skill_id = s.skill_id
       ${where}`,
      params
    );

    const total = Number(totalResult.rows[0].total || 0);

    const listResult = await db.query(
            `SELECT ps.person_id, p.person_name, p.username,
              ps.skill_id, s.skill_name, s.skill_type,
              ps.status, ps.level, ps.years, ps.frequency, ps.notes, ps.requested_at
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       JOIN skill s ON ps.skill_id = s.skill_id
       ${where}
       ORDER BY ps.requested_at ASC NULLS LAST, ps.person_id, s.skill_name
       LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
      [...params, Number(pageSize), offset]
    );

    const items = listResult.rows.map(r => ({
      person_id: r.person_id,
      name: r.person_name,
      username: r.username,
      skill: { id: r.skill_id, name: r.skill_name, type: r.skill_type },
      status: r.status,
      level: r.level,
      years: r.years,
      frequency: r.frequency,
      notes: r.notes,
      requested_at: r.requested_at,
    }));

    res.json({ page: Number(page), pageSize: Number(pageSize), total, items });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


// Get team members for the current manager
router.get('/my-team', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;

    const result = await db.query(
      `SELECT person_id, person_name, username, is_admin, manager_person_id, member_of_organization_id, role
       FROM person
       WHERE manager_person_id = $1
       ORDER BY person_name`,
      [managerId]
    );

    const teamMembers = result.rows.map(member => ({
      person_id: member.person_id,
      name: member.person_name,
      username: member.username,
      role: member.role || 'employee',
      is_admin: member.is_admin,
      manager_id: member.manager_person_id,
      organization_id: member.member_of_organization_id,
    }));

    res.json(teamMembers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Manager: consolidated approved skills for all team members
// NOTE: This route MUST come before /my-team/:memberId to avoid route conflict
router.get('/my-team/approved-skills', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const managerId = req.user.person_id;

    const result = await db.query(
      `SELECT p.person_id, p.person_name, p.username,
              s.skill_id, s.skill_name, s.skill_type,
              ps.level, ps.years, ps.frequency, ps.notes
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE p.manager_person_id = $1 AND ps.status = 'Approved'
       ORDER BY p.person_name, s.skill_name`,
      [managerId]
    );

    const items = result.rows.map(r => ({
      person_id: r.person_id,
      name: r.person_name,
      username: r.username,
      skill: { id: r.skill_id, name: r.skill_name, type: r.skill_type },
      level: r.level,
      years: r.years,
      frequency: r.frequency,
      notes: r.notes,
    }));

    res.json(items);
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
      `SELECT ps.skill_id, ps.status, ps.level, ps.years, ps.frequency, ps.notes, ps.requested_at,
              s.skill_name, s.skill_type
       FROM person_skill ps
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE ps.person_id = $1 AND ps.status <> 'Canceled'
       ORDER BY s.skill_name`,
      [memberId]
    );

    const skills = skillsResult.rows.map(skill => ({
      id: skill.skill_id,
      name: skill.skill_name,
      type: skill.skill_type,
      status: skill.status,
      level: skill.level,
      years: skill.years,
      frequency: skill.frequency,
      notes: skill.notes,
      requested_at: skill.requested_at,
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

    // Get team member count
    const teamCountResult = await db.query(
      'SELECT COUNT(*) as team_size FROM person WHERE manager_person_id = $1',
      [managerId]
    );

    // Get pending skill approvals
    const pendingResult = await db.query(
      `SELECT COUNT(*) as pending_count
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       WHERE p.manager_person_id = $1 AND ps.status = 'Requested'`,
      [managerId]
    );

    // Get skill distribution across team
    const skillDistResult = await db.query(
      `SELECT s.skill_name, s.skill_type, COUNT(*) as user_count
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE p.manager_person_id = $1 AND ps.status = 'Approved'
       GROUP BY s.skill_name, s.skill_type
       ORDER BY user_count DESC
       LIMIT 10`,
      [managerId]
    );

    // Get total approved skills count
    const approvedCountResult = await db.query(
      `SELECT COUNT(*) as approved_count
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       WHERE p.manager_person_id = $1 AND ps.status = 'Approved'`,
      [managerId]
    );

    res.json({
      team_size: parseInt(teamCountResult.rows[0].team_size),
      pending_approvals: parseInt(pendingResult.rows[0].pending_count),
      total_approved: parseInt(approvedCountResult.rows[0].approved_count),
      top_skills: skillDistResult.rows.map(row => ({
        skill_name: row.skill_name,
        skill_type: row.skill_type,
        user_count: parseInt(row.user_count),
      })),
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Approve a skill for a team member
router.patch('/my-team/:memberId/skills/:skillId/approve', authenticate, authorizeRoles('manager', 'admin'), async (req, res) => {
  try {
    const userId = req.user.person_id;
    const { memberId, skillId } = req.params;
    const isAdmin = req.user.role === 'admin';

    // Verify the member exists
    const memberCheck = await db.query(
      'SELECT person_id, manager_person_id FROM person WHERE person_id = $1',
      [memberId]
    );

    if (memberCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Team member not found' });
    }

    const member = memberCheck.rows[0];

    // Authorization: Admin can approve anyone, Manager can only approve their direct reports
    if (!isAdmin && member.manager_person_id !== userId) {
      return res.status(403).json({ error: 'Not authorized to approve skills for this team member' });
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
    const userId = req.user.person_id;
    const { memberId, skillId } = req.params;
    const isAdmin = req.user.role === 'admin';

    // Verify the member exists
    const memberCheck = await db.query(
      'SELECT person_id, manager_person_id FROM person WHERE person_id = $1',
      [memberId]
    );

    if (memberCheck.rows.length === 0) {
      return res.status(404).json({ error: 'Team member not found' });
    }

    const member = memberCheck.rows[0];

    // Authorization: Admin can reject anyone, Manager can only reject their direct reports
    if (!isAdmin && member.manager_person_id !== userId) {
      return res.status(403).json({ error: 'Not authorized to reject skills for this team member' });
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

// ===== High-Value Skills Management =====

const formatHighValueSkill = (row) => ({
  id: row.id,
  team_id: row.team_id,
  skill_id: row.skill_id,
  skill_name: row.skill_name,
  skill_type: row.skill_type,
  priority: row.priority,
  notes: row.notes,
  created_at: row.created_at,
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

module.exports = router;

// Summary of pending approvals by age buckets (admin)
router.get('/admin/requests/summary', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const result = await db.query(
      `SELECT
         COUNT(*) FILTER (WHERE ps.status = 'Requested' AND ps.requested_at IS NOT NULL AND ps.requested_at >= NOW() - INTERVAL '3 days') AS new_count,
         COUNT(*) FILTER (WHERE ps.status = 'Requested' AND ps.requested_at IS NOT NULL AND ps.requested_at < NOW() - INTERVAL '3 days' AND ps.requested_at >= NOW() - INTERVAL '7 days') AS mid_count,
         COUNT(*) FILTER (WHERE ps.status = 'Requested' AND ps.requested_at IS NOT NULL AND ps.requested_at < NOW() - INTERVAL '7 days') AS old_count,
         COUNT(*) FILTER (WHERE ps.status = 'Requested') AS pending_total
       FROM person_skill ps`
    );

    const row = result.rows[0] || {};
    res.json({
      pending_total: Number(row.pending_total || 0),
      buckets: {
        new: Number(row.new_count || 0),
        mid: Number(row.mid_count || 0),
        old: Number(row.old_count || 0),
      }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
