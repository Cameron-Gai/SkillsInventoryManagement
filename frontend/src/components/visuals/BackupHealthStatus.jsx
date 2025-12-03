import PropTypes from 'prop-types';

const statusStyles = {
  healthy: {
    bg: 'var(--accent-success-bg)',
    color: 'var(--accent-success-text)',
    border: 'var(--accent-success-border)',
  },
  warning: {
    bg: 'var(--accent-warning-bg)',
    color: 'var(--accent-warning-text)',
    border: 'var(--accent-warning-border)',
  },
  failed: {
    bg: 'var(--accent-danger-bg)',
    color: 'var(--accent-danger-text)',
    border: 'var(--accent-danger-border)',
  },
};

export default function BackupHealthStatus({ lastBackup, status = 'healthy', message }) {
  const style = statusStyles[status] || statusStyles.warning;

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm flex items-center gap-3">
      <div
        className="h-12 w-12 rounded-full border flex items-center justify-center text-xl"
        style={{
          backgroundColor: style.bg,
          color: style.color,
          borderColor: style.border,
        }}
      >
        💾
      </div>
      <div className="flex flex-col">
        <span className="text-sm text-[var(--text-color-secondary)]">Backup Health</span>
        <span className="text-lg font-semibold text-[var(--text-color)] capitalize">{status}</span>
        <span className="text-xs text-[var(--text-color-secondary)]">Last backup: {lastBackup || 'Pending schedule'}</span>
        {message ? <span className="text-xs text-[var(--text-color)] mt-1">{message}</span> : null}
      </div>
    </div>
  );
}

BackupHealthStatus.propTypes = {
  lastBackup: PropTypes.string,
  status: PropTypes.oneOf(['healthy', 'warning', 'failed']),
  message: PropTypes.string,
};
