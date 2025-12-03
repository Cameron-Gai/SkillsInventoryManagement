const db = require('../config/db');
const { ensureTeamHighValueSkillsTable } = require('./highValueSkillsTable');

function derivePriority(score) {
  if (score >= 0.3) return 'High';
  if (score >= 0.15) return 'Medium';
  return 'Low';
}

function formatNotes(row) {
  const formatPercent = (val) => {
    const pctRaw = (Number(val) || 0) * 100;
    if (pctRaw > 0 && pctRaw < 1) {
      const pct = Math.max(pctRaw, 0.1);
      return `${pct.toFixed(1)}%`;
    }
    return `${Math.round(pctRaw)}%`;
  };
  const teamPctStr = formatPercent(row.team_coverage);
  const adoptionPctStr = formatPercent(row.employee_penetration);
  const teamCount = Number(row.team_count) || 0;
  const employeeCount = Number(row.approved_employees) || 0;

  return `${teamCount} teams (${teamPctStr} coverage) marked this - ${adoptionPctStr} of employees (about ${employeeCount}) are approved`;
}

async function computeCompanyFocusSkills(limit = 6, options = {}) {
  const { organizationId = null } = options;
  await ensureTeamHighValueSkillsTable();

  const totalsQuery = organizationId
    ? `SELECT
         COUNT(DISTINCT thvs.team_id) AS total_teams,
         (SELECT COUNT(*) FROM person p WHERE p.member_of_organization_id = $1) AS total_employees
       FROM team_high_value_skills thvs
       JOIN person team_owner ON team_owner.person_id = thvs.team_id
       WHERE team_owner.member_of_organization_id = $1`
    : `SELECT
         COUNT(DISTINCT team_id) AS total_teams,
         (SELECT COUNT(*) FROM person) AS total_employees
       FROM team_high_value_skills`;

  const totalsParams = organizationId ? [organizationId] : [];
  const totalsResult = await db.query(totalsQuery, totalsParams);

  const totalTeams = Number(totalsResult.rows[0]?.total_teams) || 0;
  const totalEmployees = Number(totalsResult.rows[0]?.total_employees) || 0;

  if (totalTeams === 0 || totalEmployees === 0) {
    return [];
  }

  const result = await db.query(
    `WITH team_priorities AS (
       SELECT
         thvs.skill_id,
         thvs.team_id,
         CASE LOWER(priority)
           WHEN 'high' THEN 3
           WHEN 'medium' THEN 2
           ELSE 1
         END AS priority_score
       FROM team_high_value_skills thvs
       ${organizationId ? 'JOIN person team_owner ON team_owner.person_id = thvs.team_id WHERE team_owner.member_of_organization_id = $4' : ''}
     ),
     skill_team_stats AS (
       SELECT
         skill_id,
         COUNT(DISTINCT team_id) AS team_count,
         AVG(priority_score)::numeric AS avg_priority_score,
         SUM(priority_score)::numeric AS total_priority_score
       FROM team_priorities
       GROUP BY skill_id
     ),
     skill_employee_stats AS (
       SELECT
         ps.skill_id,
         COUNT(*) FILTER (WHERE ps.status = 'Approved') AS approved_employees
       FROM person_skill ps
       ${organizationId ? 'JOIN person employee ON employee.person_id = ps.person_id WHERE employee.member_of_organization_id = $4' : ''}
       GROUP BY ps.skill_id
     )
     SELECT
       sk.skill_id,
       sk.skill_name,
       sk.skill_type,
       sts.team_count,
       sts.avg_priority_score,
       sts.total_priority_score,
       COALESCE(ses.approved_employees, 0) AS approved_employees,
       (sts.team_count::numeric / $1) AS team_coverage,
       -- Use NULLIF to avoid division by zero and force numeric division
       COALESCE(ses.approved_employees, 0)::numeric / NULLIF($2::numeric, 0) AS employee_penetration,
       (sts.team_count::numeric / $1) *
         (1 - COALESCE(ses.approved_employees, 0)::numeric / NULLIF($2::numeric, 0)) *
         (1 + (sts.avg_priority_score - 1) / 2) AS score
     FROM skill_team_stats sts
     JOIN skill sk ON sk.skill_id = sts.skill_id
     LEFT JOIN skill_employee_stats ses ON ses.skill_id = sts.skill_id
     ORDER BY score DESC, sts.team_count DESC, sk.skill_name
     LIMIT $3`,
    organizationId ? [totalTeams, totalEmployees, limit, organizationId] : [totalTeams, totalEmployees, limit]
  );

  return result.rows.map((row) => {
    const score = Number(row.score) || 0;
    return {
      skill_id: row.skill_id,
      skill_name: row.skill_name,
      skill_type: row.skill_type,
      team_count: Number(row.team_count) || 0,
      approved_employees: Number(row.approved_employees) || 0,
      team_coverage: Number(row.team_coverage) || 0,
      employee_penetration: Number(row.employee_penetration) || 0,
      score,
      priority: derivePriority(score),
      notes: formatNotes(row),
    };
  });
}

module.exports = {
  computeCompanyFocusSkills,
};
