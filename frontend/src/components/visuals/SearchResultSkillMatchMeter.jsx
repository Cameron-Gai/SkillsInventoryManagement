import PropTypes from 'prop-types';

export default function SearchResultSkillMatchMeter({ match = 0, label = 'Skill Match' }) {
  const value = Math.min(Math.max(match, 0), 100);
  const gradient = value > 75 ? 'from-emerald-400 to-emerald-600' : value > 50 ? 'from-amber-400 to-amber-500' : 'from-rose-400 to-rose-500';

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <div className="flex items-center justify-between mb-2">
        <p className="text-sm font-semibold text-gray-800 dark:text-gray-100">{label}</p>
        <span className="text-sm text-gray-500 dark:text-gray-400">{value}%</span>
      </div>
      <div className="w-full h-3 rounded-full bg-gray-100 dark:bg-neutral-800 overflow-hidden">
        <div className={`h-full bg-gradient-to-r ${gradient}`} style={{ width: `${value}%` }} />
      </div>
      <p className="text-xs text-gray-500 dark:text-gray-400 mt-2">Higher values indicate stronger alignment to required skills.</p>
    </div>
  );
}

SearchResultSkillMatchMeter.propTypes = {
  match: PropTypes.number,
  label: PropTypes.string,
};
