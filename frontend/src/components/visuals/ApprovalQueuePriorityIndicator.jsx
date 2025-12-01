import PropTypes from 'prop-types';

export default function ApprovalQueuePriorityIndicator({ counts = {} }) {
  const { high = 0, medium = 0, low = 0 } = counts;
  const total = high + medium + low || 1;

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <div className="flex items-center justify-between mb-2">
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">Approval Queue</h3>
        <span className="text-sm text-gray-500 dark:text-gray-400">{high + medium + low} pending</span>
      </div>
      <div className="flex w-full h-3 rounded-full overflow-hidden bg-gray-100 dark:bg-neutral-800">
        <div className="bg-rose-500" style={{ width: `${(high / total) * 100}%` }} />
        <div className="bg-amber-400" style={{ width: `${(medium / total) * 100}%` }} />
        <div className="bg-emerald-400" style={{ width: `${(low / total) * 100}%` }} />
      </div>
      <div className="flex justify-between mt-3 text-xs text-gray-600 dark:text-gray-300">
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-rose-500" />High: {high}</span>
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-amber-400" />Medium: {medium}</span>
        <span className="flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-emerald-400" />Low: {low}</span>
      </div>
    </div>
  );
}

ApprovalQueuePriorityIndicator.propTypes = {
  counts: PropTypes.shape({
    high: PropTypes.number,
    medium: PropTypes.number,
    low: PropTypes.number,
  }),
};
