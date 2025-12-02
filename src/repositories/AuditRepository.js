const db = require('../config/database');
const AuditLog = require('../models/AuditLog');

/**
 * AuditRepository
 * Handles database operations for AuditLog entities
 */
class AuditRepository {
  /**
   * Create a new audit log entry
   */
  async createAuditLog(auditData) {
    const auditLog = new AuditLog(auditData);
    const dbData = auditLog.toDatabase();

    const query = `
      INSERT INTO audit_logs (
        action, user_id, target_type, target_id,
        old_value, new_value, reason, timestamp, ip_address
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *
    `;

    const result = await db.query(query, [
      dbData.action,
      dbData.user_id,
      dbData.target_type,
      dbData.target_id,
      dbData.old_value,
      dbData.new_value,
      dbData.reason,
      dbData.timestamp,
      dbData.ip_address
    ]);

    return result.rows.length > 0 ? AuditLog.fromDatabase(result.rows[0]) : null;
  }

  /**
   * Get audit logs by target (e.g., all logs for a specific skill_status_id)
   */
  async getAuditLogsByTarget(targetType, targetId) {
    const query = `
      SELECT al.*, p.first_name, p.last_name, p.username
      FROM audit_logs al
      LEFT JOIN persons p ON al.user_id = p.person_id
      WHERE al.target_type = $1 AND al.target_id = $2
      ORDER BY al.timestamp DESC
    `;
    const result = await db.query(query, [targetType, targetId]);
    return result.rows.map(row => ({
      ...AuditLog.fromDatabase(row),
      performedBy: row.username || `${row.first_name} ${row.last_name}`
    }));
  }

  /**
   * Get audit logs by user
   */
  async getAuditLogsByUser(userId, limit = 50) {
    const query = `
      SELECT * FROM audit_logs
      WHERE user_id = $1
      ORDER BY timestamp DESC
      LIMIT $2
    `;
    const result = await db.query(query, [userId, limit]);
    return result.rows.map(row => AuditLog.fromDatabase(row));
  }

  /**
   * Get recent audit logs (for dashboard/monitoring)
   */
  async getRecentAuditLogs(limit = 100) {
    const query = `
      SELECT al.*, p.first_name, p.last_name, p.username
      FROM audit_logs al
      LEFT JOIN persons p ON al.user_id = p.person_id
      ORDER BY al.timestamp DESC
      LIMIT $1
    `;
    const result = await db.query(query, [limit]);
    return result.rows.map(row => ({
      ...AuditLog.fromDatabase(row),
      performedBy: row.username || `${row.first_name} ${row.last_name}`
    }));
  }

  /**
   * Get audit logs by action type
   */
  async getAuditLogsByAction(action, limit = 50) {
    const query = `
      SELECT al.*, p.first_name, p.last_name, p.username
      FROM audit_logs al
      LEFT JOIN persons p ON al.user_id = p.person_id
      WHERE al.action = $1
      ORDER BY al.timestamp DESC
      LIMIT $2
    `;
    const result = await db.query(query, [action, limit]);
    return result.rows.map(row => ({
      ...AuditLog.fromDatabase(row),
      performedBy: row.username || `${row.first_name} ${row.last_name}`
    }));
  }
}

module.exports = new AuditRepository();
