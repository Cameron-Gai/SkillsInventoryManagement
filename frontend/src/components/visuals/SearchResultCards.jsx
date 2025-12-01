import PropTypes from 'prop-types';
import StatusBadges from './StatusBadges';
import SearchResultSkillMatchMeter from './SearchResultSkillMatchMeter';

export default function SearchResultCards({ results = [] }) {
  const fallback = results.length
    ? results
    : [
        {
          name: 'Alex Johnson',
          role: 'Frontend Engineer',
          status: 'approved',
          match: 88,
          tags: ['React', 'TypeScript', 'Design Systems'],
        },
        {
          name: 'Morgan Lee',
          role: 'Data Analyst',
          status: 'pending',
          match: 72,
          tags: ['SQL', 'Python', 'PowerBI'],
        },
      ];

  return (
    <div className="space-y-3">
      {fallback.map((item) => (
        <div
          key={item.name}
          className="bg-white dark:bg-neutral-900 rounded-lg shadow border border-gray-100 dark:border-neutral-800 p-4 space-y-3"
        >
          <div className="flex items-center justify-between">
            <div>
              <h4 className="text-lg font-semibold text-gray-800 dark:text-gray-100">{item.name}</h4>
              <p className="text-sm text-gray-500 dark:text-gray-400">{item.role}</p>
            </div>
            <StatusBadges status={item.status} />
          </div>
          <div className="flex flex-wrap gap-2">
            {item.tags?.map((tag) => (
              <span key={tag} className="px-2 py-1 rounded-full bg-gray-100 dark:bg-neutral-800 text-xs text-gray-700 dark:text-gray-200">
                {tag}
              </span>
            ))}
          </div>
          <SearchResultSkillMatchMeter match={item.match} label="Skill Match" />
        </div>
      ))}
    </div>
  );
}

SearchResultCards.propTypes = {
  results: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string.isRequired,
      role: PropTypes.string,
      status: PropTypes.string,
      match: PropTypes.number,
      tags: PropTypes.arrayOf(PropTypes.string),
    }),
  ),
};
