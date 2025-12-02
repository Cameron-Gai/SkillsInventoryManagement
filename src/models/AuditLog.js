/**
 * AuditLog Model
 * Tracks all approval/rejection actions for audit trail
 * Corresponds to the AuditLog entity in the static diagram
 */
class AuditLog {
  constructor(data) {
    this.auditId = data.auditId || data.audit_id;
    this.action = data.action; // e.g., 'APPROVE', 'REJECT', 'CREATE', 'UPDATE'
    this.userId = data.userId || data.user_id; // Who performed the action
    this.targetType = data.targetType || data.target_type; // e.g., 'SKILL', 'SKILL_STATUS'
    this.targetId = data.targetId || data.target_id; // ID of the affected entity
    this.oldValue = data.oldValue || data.old_value; // Previous state (JSON)
    this.newValue = data.newValue || data.new_value; // New state (JSON)
    this.reason = data.reason; // Optional reason for the action
    this.timestamp = data.timestamp || new Date();
    this.ipAddress = data.ipAddress || data.ip_address;
  }

  /**
   * Convert to database format (snake_case)
   */
  toDatabase() {
    return {
      audit_id: this.auditId,
      action: this.action,
      user_id: this.userId,
      target_type: this.targetType,
      target_id: this.targetId,
      old_value: typeof this.oldValue === 'object' ? JSON.stringify(this.oldValue) : this.oldValue,
      new_value: typeof this.newValue === 'object' ? JSON.stringify(this.newValue) : this.newValue,
      reason: this.reason,
      timestamp: this.timestamp,
      ip_address: this.ipAddress
    };
  }

  /**
   * Create from database row (snake_case to camelCase)
   */
  static fromDatabase(row) {
    if (!row) return null;
    return new AuditLog({
      auditId: row.audit_id,
      action: row.action,
      userId: row.user_id,
      targetType: row.target_type,
      targetId: row.target_id,
      oldValue: row.old_value,
      newValue: row.new_value,
      reason: row.reason,
      timestamp: row.timestamp,
      ipAddress: row.ip_address
    });
  }
}

module.exports = AuditLog;
