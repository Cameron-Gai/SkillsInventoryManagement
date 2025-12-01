import PropTypes from 'prop-types';

const formatNumber = (value) => new Intl.NumberFormat().format(value);

export default function DataVolumeCounters({ items = {} }) {
  const { skills = 0, employees = 0, teams = 0, audits = 0 } = items;

  const counters = [
    { label: 'Skills', value: skills, accent: 'bg-indigo-100 text-indigo-700' },
    { label: 'Employees', value: employees, accent: 'bg-emerald-100 text-emerald-700' },
    { label: 'Teams', value: teams, accent: 'bg-amber-100 text-amber-700' },
    { label: 'Audit Entries', value: audits, accent: 'bg-rose-100 text-rose-700' },
  ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-4">Data Volume</h3>
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        {counters.map((item) => (
          <div key={item.label} className="p-3 rounded-lg border border-gray-200 dark:border-neutral-700">
            <p className="text-sm text-gray-500 dark:text-gray-400">{item.label}</p>
            <p className={`text-2xl font-bold mt-1 inline-flex px-2 py-1 rounded ${item.accent}`}>
              {formatNumber(item.value)}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
}

DataVolumeCounters.propTypes = {
  items: PropTypes.shape({
    skills: PropTypes.number,
    employees: PropTypes.number,
    teams: PropTypes.number,
    audits: PropTypes.number,
  }),
};
