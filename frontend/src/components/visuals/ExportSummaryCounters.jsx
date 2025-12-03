import PropTypes from 'prop-types';

export default function ExportSummaryCounters({ summary = {} }) {
  const { files = 0, rows = 0, duration = '—' } = summary;
  const items = [
    { label: 'Files Generated', value: files, color: 'var(--accent-info-text)' },
    { label: 'Rows Exported', value: rows, color: 'var(--accent-success-text)' },
    { label: 'Duration', value: duration, color: 'var(--accent-warning-text)' },
  ];

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Export Summary</h3>
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
        {items.map((item) => (
          <div key={item.label} className="p-3 rounded-xl border border-[var(--border-color)] bg-[var(--background-muted)]">
            <p className="text-xs uppercase tracking-wide text-[var(--text-color-secondary)]">{item.label}</p>
            <p className="text-2xl font-bold mt-1" style={{ color: item.color }}>
              {item.value}
            </p>
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
