const express = require('express');
const { authenticate } = require('../config/auth/authMiddleware');
const { authorizeRoles } = require('../config/auth/requireRole');
const db = require('../config/db');

const router = express.Router();

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
      `SELECT s.skill_name, COUNT(*) as user_count
       FROM person_skill ps
       JOIN person p ON ps.person_id = p.person_id
       JOIN skill s ON ps.skill_id = s.skill_id
       WHERE p.manager_person_id = $1 AND ps.status = 'Approved'
       GROUP BY s.skill_name
       ORDER BY user_count DESC
       LIMIT 10`,
      [managerId]
    );

    res.json({
      team_size: parseInt(teamCountResult.rows[0].team_size),
      pending_approvals: parseInt(pendingResult.rows[0].pending_count),
      top_skills: skillDistResult.rows.map(row => ({
        skill_name: row.skill_name,
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
