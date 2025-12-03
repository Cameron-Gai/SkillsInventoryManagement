// Seed employee skills for the current schema
// Assigns a mix of Approved and Requested skills to all employees

const db = require('../config/db');

async function getAllEmployees() {
  const res = await db.query(
    `SELECT person_id, person_name, username
     FROM person
     WHERE COALESCE(role, 'employee') = 'employee'`
  );
  return res.rows;
}

async function getAllSkills() {
  const res = await db.query(
    `SELECT skill_id, skill_name, skill_type
     FROM skill`
  );
  return res.rows;
}

function pickRandomDistinct(items, count) {
  const n = Math.min(count, items.length);
  const indices = new Set();
  while (indices.size < n) {
    indices.add(Math.floor(Math.random() * items.length));
  }
  return Array.from(indices).map(i => items[i]);
}

async function ensureNoDuplicate(personId, skillId) {
  const existing = await db.query(
    `SELECT 1 FROM person_skill WHERE person_id = $1 AND skill_id = $2`,
    [personId, skillId]
  );
  return existing.rowCount === 0;
}

async function insertPersonSkill(personId, skillId, status, options = {}) {
  const { level = null, years = null, frequency = null, notes = null, requestedAt = null } = options;
  const canInsert = await ensureNoDuplicate(personId, skillId);
  if (!canInsert) return false;
  await db.query(
    `INSERT INTO person_skill (person_id, skill_id, status, level, years, frequency, notes, requested_at)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
    [personId, skillId, status, level, years, frequency, notes, requestedAt]
  );
  return true;
}

function randomFrom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

async function seed() {
  try {
    console.log('Seeding employee skills...');
    const employees = await getAllEmployees();
    const skills = await getAllSkills();
    if (employees.length === 0 || skills.length === 0) {
      console.log('No employees or skills found; nothing to seed.');
      return;
    }

    const possibleLevels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];
    const possibleFrequency = ['Daily', 'Weekly', 'Monthly', 'Rarely'];

    let totalInserted = 0;
    for (const emp of employees) {
      // Assign each employee 4-8 skills
      const assignCount = 4 + Math.floor(Math.random() * 5); // 4..8
      const chosenSkills = pickRandomDistinct(skills, assignCount);

      for (const sk of chosenSkills) {
        // 60% Approved, 40% Requested
        const status = Math.random() < 0.6 ? 'Approved' : 'Requested';
        const years = status === 'Approved' ? Math.floor(Math.random() * 11) : null; // 0..10
        const level = status === 'Approved' ? randomFrom(possibleLevels) : null;
        const frequency = status === 'Approved' ? randomFrom(possibleFrequency) : null;
        const notes = status === 'Approved' ? `Seeded: ${sk.skill_name}` : `Requested by ${emp.person_name}`;
        const requestedAt = status === 'Requested' ? new Date() : null;

        const inserted = await insertPersonSkill(emp.person_id, sk.skill_id, status, {
          level,
          years,
          frequency,
          notes,
          requestedAt,
        });
        if (inserted) totalInserted += 1;
      }
    }

    console.log(`Seeding complete. Inserted ${totalInserted} person_skill rows.`);
  } catch (err) {
    console.error('Seeding failed:', err);
    throw err;
  } finally {
    // Optional: end pooled connections in some environments
    if (db.end) {
      try { await db.end(); } catch {}
    }
  }
}

seed();
