import PropTypes from 'prop-types';

const formatNumber = (value) => new Intl.NumberFormat().format(value);

export default function DataVolumeCounters({ items = {}, showTeams = true, auditLabel = 'Pending Skill Requests' }) {
  const { skills = 0, employees = 0, teams = 0, audits = 0 } = items;

  const counters = [
    {
      label: 'Skills',
      value: skills,
      accent: {
        backgroundColor: 'var(--accent-info-bg)',
        color: 'var(--accent-info-text)',
        borderColor: 'var(--accent-info-border)',
      },
    },
    {
      label: 'Employees',
      value: employees,
      accent: {
        backgroundColor: 'var(--accent-success-bg)',
        color: 'var(--accent-success-text)',
        borderColor: 'var(--accent-success-border)',
      },
    },
    {
      label: auditLabel,
      value: audits,
      accent: {
        backgroundColor: 'var(--accent-danger-bg)',
        color: 'var(--accent-danger-text)',
        borderColor: 'var(--accent-danger-border)',
      },
    },
  ];

  if (showTeams) {
    counters.splice(2, 0, {
      label: 'Teams',
      value: teams,
      accent: {
        backgroundColor: 'var(--accent-warning-bg)',
        color: 'var(--accent-warning-text)',
        borderColor: 'var(--accent-warning-border)',
      },
    });
  }

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-4">Data Volume</h3>
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        {counters.map((item) => (
          <div key={item.label} className="p-3 rounded-xl border border-[var(--border-color)] bg-[var(--background-muted)]">
            <p className="text-sm text-[var(--text-color-secondary)]">{item.label}</p>
            <p
              className="text-2xl font-bold mt-1 inline-flex px-2 py-1 rounded-full border"
              style={item.accent}
            >
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
  showTeams: PropTypes.bool,
  auditLabel: PropTypes.string,
};
