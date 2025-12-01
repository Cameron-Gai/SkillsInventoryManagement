import PropTypes from 'prop-types';

const statusStyles = {
  healthy: 'text-emerald-700 bg-emerald-100 border-emerald-200',
  warning: 'text-amber-700 bg-amber-100 border-amber-200',
  failed: 'text-rose-700 bg-rose-100 border-rose-200',
};

export default function BackupHealthStatus({ lastBackup, status = 'healthy', message }) {
  const style = statusStyles[status] || statusStyles.warning;

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4 flex items-center gap-3">
      <div className={`h-12 w-12 rounded-full border flex items-center justify-center text-xl ${style}`}>💾</div>
      <div className="flex flex-col">
        <span className="text-sm text-gray-500 dark:text-gray-400">Backup Health</span>
        <span className="text-lg font-semibold text-gray-800 dark:text-gray-100 capitalize">{status}</span>
        <span className="text-xs text-gray-500 dark:text-gray-400">Last backup: {lastBackup || 'Pending schedule'}</span>
        {message ? <span className="text-xs text-gray-600 dark:text-gray-300 mt-1">{message}</span> : null}
      </div>
    </div>
  );
}

BackupHealthStatus.propTypes = {
  lastBackup: PropTypes.string,
  status: PropTypes.oneOf(['healthy', 'warning', 'failed']),
  message: PropTypes.string,
};
