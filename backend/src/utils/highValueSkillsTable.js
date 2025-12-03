const db = require('../config/db');

async function ensureTeamHighValueSkillsTable() {
  try {
    await db.query(`
      CREATE TABLE IF NOT EXISTS team_high_value_skills (
        id SERIAL PRIMARY KEY,
        team_id INT NOT NULL REFERENCES person(person_id) ON DELETE CASCADE,
        skill_id INT NOT NULL REFERENCES skill(skill_id) ON DELETE CASCADE,
        priority VARCHAR(20) DEFAULT 'High',
        notes TEXT,
        created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
        assigned_by INT REFERENCES person(person_id) ON DELETE SET NULL,
        UNIQUE(team_id, skill_id)
      )
    `);
  } catch (err) {
    // Table already exists, which is fine
    if (err.code !== '42P07') {
      throw err;
    }
  }
}

module.exports = {
  ensureTeamHighValueSkillsTable,
};
