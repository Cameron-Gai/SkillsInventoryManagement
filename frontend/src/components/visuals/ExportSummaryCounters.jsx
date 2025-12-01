import PropTypes from 'prop-types';

export default function ExportSummaryCounters({ summary = {} }) {
  const { files = 0, rows = 0, duration = '—' } = summary;
  const items = [
    { label: 'Files Generated', value: files, color: 'text-indigo-600' },
    { label: 'Rows Exported', value: rows, color: 'text-emerald-600' },
    { label: 'Duration', value: duration, color: 'text-amber-600' },
  ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">Export Summary</h3>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
        {items.map((item) => (
          <div key={item.label} className="p-3 rounded-lg border border-gray-100 dark:border-neutral-800">
            <p className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">{item.label}</p>
            <p className={`text-2xl font-bold mt-1 ${item.color}`}>{item.value}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

ExportSummaryCounters.propTypes = {
  summary: PropTypes.shape({
    files: PropTypes.number,
    rows: PropTypes.number,
    duration: PropTypes.string,
  }),
};
