const db = require('../config/db');

let teamTableEnsured = false;
let companyTableEnsured = false;

async function migrateLegacyManagerHighValueSkills() {
  const legacyCheck = await db.query(
    "SELECT to_regclass('public.manager_high_value_skills') AS table_name"
  );

  if (!legacyCheck.rows[0]?.table_name) {
    return;
  }

  await db.query(`
    INSERT INTO team_high_value_skills (team_id, skill_id, priority, notes, created_at, assigned_by)
    SELECT manager_id, skill_id, priority, notes, created_at, manager_id
    FROM manager_high_value_skills
    ON CONFLICT (team_id, skill_id) DO NOTHING
  `);
}

async function ensureTeamHighValueSkillsTable() {
  if (teamTableEnsured) return;

  await db.query(`
    CREATE TABLE IF NOT EXISTS team_high_value_skills (
      id SERIAL PRIMARY KEY,
      team_id INTEGER NOT NULL REFERENCES person(person_id) ON DELETE CASCADE,
      skill_id INTEGER NOT NULL REFERENCES skill(skill_id) ON DELETE CASCADE,
      priority VARCHAR(20) DEFAULT 'High',
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      assigned_by INTEGER REFERENCES person(person_id) ON DELETE SET NULL,
      UNIQUE (team_id, skill_id)
    )
  `);

  await migrateLegacyManagerHighValueSkills();

  teamTableEnsured = true;
}

async function ensureCompanyDesiredSkillsTable() {
  if (companyTableEnsured) return;

  await db.query(`
    CREATE TABLE IF NOT EXISTS company_desired_skills (
      id SERIAL PRIMARY KEY,
      skill_id INTEGER NOT NULL REFERENCES skill(skill_id) ON DELETE CASCADE,
      priority VARCHAR(20) DEFAULT 'High',
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      created_by INTEGER REFERENCES person(person_id) ON DELETE SET NULL,
      UNIQUE (skill_id)
    )
  `);

  companyTableEnsured = true;
}

module.exports = {
  ensureTeamHighValueSkillsTable,
  ensureCompanyDesiredSkillsTable,
};
