const db = require('./src/config/db');
const bcrypt = require('bcrypt');

(async () => {
  try {
    const username = 'mylo.hobbs';
    const password = 'changeme123';
    
    console.log('Testing login for:', username);
    
    const result = await db.query(
      'SELECT person_id, username, role, password FROM person WHERE username = $1',
      [username]
    );
    
    if (result.rows.length === 0) {
      console.log('❌ User not found');
      process.exit(1);
    }
    
    const user = result.rows[0];
    console.log('✅ User found:', user.username);
    console.log('   Role:', user.role);
    console.log('   Has password:', user.password ? 'Yes' : 'No');
    
    if (!user.password) {
      console.log('❌ No password set for user');
      process.exit(1);
    }
    
    const match = await bcrypt.compare(password, user.password);
    console.log('   Password match:', match ? '✅ YES' : '❌ NO');
    
    if (match) {
      console.log('\n✅ Login should work!');
    } else {
      console.log('\n❌ Password does not match');
    }
    
    process.exit(0);
  } catch (e) {
    console.error('❌ Error:', e.message);
    process.exit(1);
  }
})();
