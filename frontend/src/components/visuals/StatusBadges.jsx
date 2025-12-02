import PropTypes from 'prop-types';

const statusConfig = {
  pending: {
    label: 'Pending',
    style: {
      backgroundColor: 'var(--accent-warning-bg)',
      color: 'var(--accent-warning-text)',
      borderColor: 'var(--accent-warning-border)',
    },
  },
  requested: {
    label: 'Requested',
    style: {
      backgroundColor: 'var(--accent-warning-bg)',
      color: 'var(--accent-warning-text)',
      borderColor: 'var(--accent-warning-border)',
    },
  },
  great: {
    label: 'Great',
    style: {
      backgroundColor: 'var(--accent-success-bg)',
      color: 'var(--accent-success-text)',
      borderColor: 'var(--accent-success-border)',
    },
  },
  good: {
    label: 'Good',
    style: {
      backgroundColor: 'var(--accent-success-bg)',
      color: 'var(--accent-success-text)',
      borderColor: 'var(--accent-success-border)',
    },
  },
  okay: {
    label: 'Okay',
    style: {
      backgroundColor: 'var(--accent-warning-bg)',
      color: 'var(--accent-warning-text)',
      borderColor: 'var(--accent-warning-border)',
    },
  },
  needs_work: {
    label: 'Needs Work',
    style: {
      backgroundColor: 'var(--accent-danger-bg)',
      color: 'var(--accent-danger-text)',
      borderColor: 'var(--accent-danger-border)',
    },
  },
  approved: {
    label: 'Approved',
    style: {
      backgroundColor: 'var(--accent-success-bg)',
      color: 'var(--accent-success-text)',
      borderColor: 'var(--accent-success-border)',
    },
  },
  rejected: {
    label: 'Rejected',
    style: {
      backgroundColor: 'var(--accent-danger-bg)',
      color: 'var(--accent-danger-text)',
      borderColor: 'var(--accent-danger-border)',
    },
  },
};

export default function StatusBadges({ status }) {
  const config = statusConfig[status?.toLowerCase()] || statusConfig.pending;
  return (
    <span
      className="inline-flex items-center gap-2 px-3 py-1 rounded-full border text-sm font-medium"
      aria-label={`${config.label} status`}
      style={config.style}
    >
      <span className="h-2.5 w-2.5 rounded-full bg-current" aria-hidden />
      {config.label}
    </span>
  );
}

StatusBadges.propTypes = {
  status: PropTypes.oneOf(['pending', 'requested', 'approved', 'rejected', 'great', 'good', 'okay', 'needs_work']),
};
