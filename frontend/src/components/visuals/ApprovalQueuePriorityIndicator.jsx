import PropTypes from 'prop-types';

export default function ApprovalQueuePriorityIndicator({ counts = {} }) {
  const { overWeek = 0, overThree = 0, underThree = 0 } = counts;
  const total = overWeek + overThree + underThree || 1;

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-center justify-between mb-2">
        <h3 className="text-lg font-semibold text-[var(--text-color)]">Approval Queue</h3>
        <span className="text-sm text-[var(--text-color-secondary)]">{overWeek + overThree + underThree} pending</span>
      </div>
      <div className="flex w-full h-3 rounded-full overflow-hidden border border-[var(--border-color)] bg-[var(--background-muted)]">
        <div className="bg-emerald-400" style={{ width: `${(underThree / total) * 100}%` }} />
        <div className="bg-amber-400" style={{ width: `${(overThree / total) * 100}%` }} />
        <div className="bg-rose-500" style={{ width: `${(overWeek / total) * 100}%` }} />
      </div>
      <div className="flex justify-between mt-3 text-xs text-[var(--text-color-secondary)]">
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-emerald-400" />New: {underThree}</span>
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-amber-400" />4-7 days: {overThree}</span>
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-rose-500" />Over 7 days: {overWeek}</span>
      </div>
    </div>
  );
}

ApprovalQueuePriorityIndicator.propTypes = {
  counts: PropTypes.shape({
    overWeek: PropTypes.number,
    overThree: PropTypes.number,
    underThree: PropTypes.number,
  }),
};
