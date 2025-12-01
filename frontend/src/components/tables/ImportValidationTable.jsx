import PropTypes from 'prop-types';

const rowColors = {
  valid: 'bg-emerald-50 dark:bg-emerald-900/40',
  warning: 'bg-amber-50 dark:bg-amber-900/40',
  error: 'bg-rose-50 dark:bg-rose-900/40',
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
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow overflow-hidden">
      <div className="px-4 py-3 border-b border-gray-100 dark:border-neutral-800 flex items-center justify-between">
        <div>
          <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">Import Validation</h3>
          <p className="text-xs text-gray-500 dark:text-gray-400">Color-coded quality checks before saving.</p>
        </div>
      </div>
      <div className="overflow-x-auto">
        <table className="min-w-full text-left text-sm">
          <thead className="bg-gray-50 dark:bg-neutral-800 text-gray-600 dark:text-gray-300">
            <tr>
              <th className="px-4 py-2">Field</th>
              <th className="px-4 py-2">Value</th>
              <th className="px-4 py-2">Status</th>
              <th className="px-4 py-2">Message</th>
            </tr>
          </thead>
          <tbody>
            {tableRows.map((row) => (
              <tr key={`${row.field}-${row.value}`} className={rowColors[row.status] || rowColors.warning}>
                <td className="px-4 py-2 font-medium text-gray-800 dark:text-gray-100">{row.field}</td>
                <td className="px-4 py-2 text-gray-700 dark:text-gray-200">{row.value}</td>
                <td className="px-4 py-2 capitalize text-gray-700 dark:text-gray-200">{row.status}</td>
                <td className="px-4 py-2 text-gray-600 dark:text-gray-300">{row.message}</td>
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
