const bcrypt = require('bcrypt');
const db = require('../db');

async function seedPasswords(defaultPassword = 'changeme123') {
  try {
    const users = await db.query('SELECT person_id FROM person');
    for (const user of users.rows) {
      const hash = await bcrypt.hash(defaultPassword, 10);
      await db.query('UPDATE person SET password = $1 WHERE person_id = $2', [hash, user.person_id]);
    }
    console.log('Passwords seeded successfully!');
    process.exit(0);
  } catch (err) {
    console.error('Error seeding passwords:', err);
    process.exit(1);
  }
}

seedPasswords();
