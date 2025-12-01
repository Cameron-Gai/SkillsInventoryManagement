import PropTypes from 'prop-types';

const statusConfig = {
  pending: { label: 'Pending', color: 'bg-amber-100 text-amber-700 border-amber-300' },
  approved: { label: 'Approved', color: 'bg-emerald-100 text-emerald-700 border-emerald-300' },
  rejected: { label: 'Rejected', color: 'bg-rose-100 text-rose-700 border-rose-300' },
};

export default function StatusBadges({ status }) {
  const config = statusConfig[status?.toLowerCase()] || statusConfig.pending;
  return (
    <span
      className={`inline-flex items-center gap-2 px-3 py-1 rounded-full border text-sm font-medium ${config.color}`}
      aria-label={`${config.label} status`}
    >
      <span className="h-2.5 w-2.5 rounded-full bg-current" aria-hidden />
      {config.label}
    </span>
  );
}

StatusBadges.propTypes = {
  status: PropTypes.oneOf(['pending', 'approved', 'rejected']),
};
