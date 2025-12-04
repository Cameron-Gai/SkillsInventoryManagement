const express = require('express');
const { authenticate, authorizeRoles } = require('../config/auth/authMiddleware');
const { exec } = require('child_process');
const { promisify } = require('util');
const fs = require('fs').promises;
const path = require('path');

const execAsync = promisify(exec);
const router = express.Router();

const BACKUP_DIR = path.join(__dirname, '../../backups');

// Ensure backup directory exists
async function ensureBackupDir() {
  try {
    await fs.mkdir(BACKUP_DIR, { recursive: true });
  } catch (err) {
    console.error('Error creating backup directory:', err);
  }
}

// Create database backup
router.post('/backup', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureBackupDir();
    
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `backup_${timestamp}.sql`;
    const filepath = path.join(BACKUP_DIR, filename);
    
    const dbConfig = {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
    };

    // Use pg_dump to create backup
    const command = `pg_dump -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} -d ${dbConfig.database} -F p -f "${filepath}"`;
    
    // Set PGPASSWORD environment variable for the command
    const env = { ...process.env, PGPASSWORD: process.env.DB_PASSWORD };
    
    await execAsync(command, { env });
    
    res.json({
      success: true,
      message: 'Backup created successfully',
      filename,
      timestamp: new Date().toISOString(),
      size: (await fs.stat(filepath)).size,
    });
  } catch (err) {
    console.error('Backup error:', err);
    res.status(500).json({ error: 'Failed to create backup: ' + err.message });
  }
});

// List all backups
router.get('/backups', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    await ensureBackupDir();
    const files = await fs.readdir(BACKUP_DIR);
    
    const backups = await Promise.all(
      files
        .filter(f => f.endsWith('.sql'))
        .map(async (filename) => {
          const filepath = path.join(BACKUP_DIR, filename);
          const stats = await fs.stat(filepath);
          return {
            filename,
            size: stats.size,
            created: stats.birthtime,
            modified: stats.mtime,
          };
        })
    );
    
    // Sort by creation date, newest first
    backups.sort((a, b) => b.created - a.created);
    
    res.json(backups);
  } catch (err) {
    console.error('List backups error:', err);
    res.status(500).json({ error: 'Failed to list backups: ' + err.message });
  }
});

// Download backup file
router.get('/backup/:filename', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { filename } = req.params;
    
    // Validate filename to prevent directory traversal
    if (filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({ error: 'Invalid filename' });
    }
    
    const filepath = path.join(BACKUP_DIR, filename);
    
    // Check if file exists
    await fs.access(filepath);
    
    res.download(filepath, filename);
  } catch (err) {
    console.error('Download backup error:', err);
    res.status(404).json({ error: 'Backup file not found' });
  }
});

// Delete backup
router.delete('/backup/:filename', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { filename } = req.params;
    
    // Validate filename
    if (filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({ error: 'Invalid filename' });
    }
    
    const filepath = path.join(BACKUP_DIR, filename);
    await fs.unlink(filepath);
    
    res.json({ success: true, message: 'Backup deleted successfully' });
  } catch (err) {
    console.error('Delete backup error:', err);
    res.status(500).json({ error: 'Failed to delete backup: ' + err.message });
  }
});

// Restore from backup
router.post('/restore/:filename', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const { filename } = req.params;
    
    // Validate filename
    if (filename.includes('..') || filename.includes('/') || filename.includes('\\')) {
      return res.status(400).json({ error: 'Invalid filename' });
    }
    
    const filepath = path.join(BACKUP_DIR, filename);
    
    // Check if file exists
    await fs.access(filepath);
    
    const dbConfig = {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME,
      user: process.env.DB_USER,
    };

    // Use psql to restore
    const command = `psql -h ${dbConfig.host} -p ${dbConfig.port} -U ${dbConfig.user} -d ${dbConfig.database} -f "${filepath}"`;
    
    const env = { ...process.env, PGPASSWORD: process.env.DB_PASSWORD };
    
    await execAsync(command, { env });
    
    res.json({
      success: true,
      message: 'Database restored successfully',
      filename,
      timestamp: new Date().toISOString(),
    });
  } catch (err) {
    console.error('Restore error:', err);
    res.status(500).json({ error: 'Failed to restore backup: ' + err.message });
  }
});

// Export all data as JSON
router.get('/export/json', authenticate, authorizeRoles('admin'), async (req, res) => {
  try {
    const db = require('../config/db');
    
    // Export all tables
    const tables = ['organization', 'person', 'skill', 'person_skill', 'project', 
                    'project_skill_required', 'person_project_assignment', 'team_high_value_skills'];
    
    const exportData = {};
    
    for (const table of tables) {
      try {
        const result = await db.query(`SELECT * FROM ${table}`);
        exportData[table] = result.rows;
      } catch (err) {
        console.error(`Error exporting ${table}:`, err);
        exportData[table] = [];
      }
    }
    
    exportData.exported_at = new Date().toISOString();
    exportData.exported_by = req.user.person_id;
    
    res.json(exportData);
  } catch (err) {
    console.error('Export error:', err);
    res.status(500).json({ error: 'Failed to export data: ' + err.message });
  }
});

module.exports = router;
