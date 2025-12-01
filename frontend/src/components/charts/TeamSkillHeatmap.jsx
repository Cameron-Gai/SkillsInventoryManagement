import PropTypes from 'prop-types';

function getColor(level) {
  if (level >= 4) return 'bg-emerald-500/80';
  if (level >= 3) return 'bg-emerald-400/70';
  if (level >= 2) return 'bg-amber-400/70';
  if (level >= 1) return 'bg-rose-300/70';
  return 'bg-gray-200 dark:bg-neutral-700';
}

export default function TeamSkillHeatmap({ data = [], skills = [] }) {
  const fallback = [
    { member: 'A. Lee', skills: { React: 4, Node: 3, SQL: 2 } },
    { member: 'M. Patel', skills: { React: 3, Node: 2, SQL: 4 } },
    { member: 'S. Kim', skills: { React: 5, Node: 4, SQL: 3 } },
  ];

  const gridData = data.length ? data : fallback;
  const skillKeys = skills.length ? skills : Array.from(new Set(gridData.flatMap((row) => Object.keys(row.skills || {}))));

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4 overflow-auto">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">Team Skill Heatmap</h3>
      <div className="min-w-full">
        <div className="grid" style={{ gridTemplateColumns: `160px repeat(${skillKeys.length}, minmax(80px, 1fr))` }}>
          <div className="text-xs font-semibold text-gray-500" />
          {skillKeys.map((skill) => (
            <div key={skill} className="text-xs font-semibold text-gray-500 text-center px-2">
              {skill}
            </div>
          ))}
          {gridData.map((row) => (
            <div key={row.member} className="contents">
              <div className="text-sm font-medium text-gray-800 dark:text-gray-100 py-2">{row.member}</div>
              {skillKeys.map((skill) => {
                const level = row.skills?.[skill] ?? 0;
                return (
                  <div key={`${row.member}-${skill}`} className="h-12 flex items-center justify-center">
                    <div
                      className={`h-9 w-9 rounded-md flex items-center justify-center text-xs font-semibold text-white ${getColor(level)}`}
                      title={`${skill}: Level ${level}`}
                    >
                      {level || '-'}
                    </div>
                  </div>
                );
              })}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

TeamSkillHeatmap.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      member: PropTypes.string.isRequired,
      skills: PropTypes.objectOf(PropTypes.number).isRequired,
    }),
  ),
  skills: PropTypes.arrayOf(PropTypes.string),
};
