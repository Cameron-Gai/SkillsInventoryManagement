#!/usr/bin/env node
const path = require('path');

const backendNodeModules = path.join(__dirname, '..', 'backend', 'node_modules');
if (!module.paths.includes(backendNodeModules)) {
  module.paths.push(backendNodeModules);
}

const dotenv = require('dotenv');

const envPath = path.join(__dirname, '..', 'backend', '.env');
dotenv.config({ path: envPath });

const db = require('../backend/src/config/db');
const { hashPassword } = require('../backend/src/utils/hash');

const DEFAULT_PASSWORD = process.env.DEFAULT_USER_PASSWORD || 'Password123!';

async function main() {
  try {
    const { rows } = await db.query('SELECT person_id, username, password FROM person');

    if (rows.length === 0) {
      console.log('No people found. Did you run the Excel seed first?');
      return;
    }

    let updated = 0;
    for (const row of rows) {
      const hasBcryptHash = typeof row.password === 'string' && /^\$2[aby]\$/i.test(row.password);
      if (!hasBcryptHash) {
        const hashed = await hashPassword(DEFAULT_PASSWORD);
        await db.query('UPDATE person SET password = $1 WHERE person_id = $2', [hashed, row.person_id]);
        updated += 1;
      }
    }

    if (updated === 0) {
      console.log('All user passwords already look hashed. Nothing to do.');
    } else {
      console.log(`Set hashed passwords for ${updated} user(s). Default password: ${DEFAULT_PASSWORD}`);
    }
  } catch (err) {
    console.error('Failed to set passwords:', err);
    process.exitCode = 1;
  } finally {
    await db.end();
  }
}

main();
