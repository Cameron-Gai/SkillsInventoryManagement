import PropTypes from 'prop-types';

const rowStyles = {
  valid: { backgroundColor: 'var(--accent-success-bg)' },
  warning: { backgroundColor: 'var(--accent-warning-bg)' },
  error: { backgroundColor: 'var(--accent-danger-bg)' },
};

export default function ImportValidationTable({ rows = [] }) {
  const tableRows = rows.length
    ? rows
    : [
        { field: 'Employee ID', value: 'E-102', status: 'valid', message: 'OK' },
        { field: 'Skill', value: 'React', status: 'valid', message: 'Recognized skill' },
        { field: 'Level', value: '7', status: 'warning', message: 'Capped at 5' },
        { field: 'Manager ID', value: 'M-404', status: 'error', message: 'Manager not found' },
      ];

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] shadow-sm overflow-hidden">
      <div className="px-4 py-3 border-b border-[var(--border-color)] flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-[var(--text-color)]">Import Validation</h3>
          <p className="text-xs text-[var(--text-color-secondary)]">Color-coded quality checks before saving.</p>
        </div>
      </div>
      <div className="overflow-x-auto">
        <table className="min-w-full text-left text-sm">
          <thead className="bg-[var(--background-muted)] text-[var(--text-color-secondary)]">
            <tr>
              <th className="px-4 py-2">Field</th>
              <th className="px-4 py-2">Value</th>
              <th className="px-4 py-2">Status</th>
              <th className="px-4 py-2">Message</th>
            </tr>
          </thead>
          <tbody>
            {tableRows.map((row) => (
              <tr key={`${row.field}-${row.value}`} style={rowStyles[row.status] || rowStyles.warning}>
                <td className="px-4 py-2 font-medium text-[var(--text-color)]">{row.field}</td>
                <td className="px-4 py-2 text-[var(--text-color-secondary)]">{row.value}</td>
                <td className="px-4 py-2 capitalize text-[var(--text-color-secondary)]">{row.status}</td>
                <td className="px-4 py-2 text-[var(--text-color-secondary)]">{row.message}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

ImportValidationTable.propTypes = {
  rows: PropTypes.arrayOf(
    PropTypes.shape({
      field: PropTypes.string.isRequired,
      value: PropTypes.string,
      status: PropTypes.oneOf(['valid', 'warning', 'error']).isRequired,
      message: PropTypes.string,
    }),
  ),
};
