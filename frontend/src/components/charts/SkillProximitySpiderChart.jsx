import PropTypes from 'prop-types';
import { RadarChart, Radar, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer, Tooltip } from 'recharts';

export default function SkillProximitySpiderChart({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { skill: 'React', proximity: 95 },
        { skill: 'Next.js', proximity: 82 },
        { skill: 'TypeScript', proximity: 76 },
        { skill: 'Node', proximity: 68 },
        { skill: 'GraphQL', proximity: 54 },
      ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">Skill Proximity</h3>
      <ResponsiveContainer width="100%" height={300}>
        <RadarChart data={chartData} cx="50%" cy="50%" outerRadius="70%">
          <PolarGrid />
          <PolarAngleAxis dataKey="skill" tick={{ fill: '#6b7280' }} />
          <PolarRadiusAxis angle={30} domain={[0, 100]} tick={{ fill: '#6b7280' }} />
          <Radar name="Match" dataKey="proximity" stroke="#6366f1" fill="#6366f1" fillOpacity={0.5} />
          <Tooltip formatter={(value) => `${value}% overlap`} />
        </RadarChart>
      </ResponsiveContainer>
    </div>
  );
}

SkillProximitySpiderChart.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      skill: PropTypes.string.isRequired,
      proximity: PropTypes.number.isRequired,
    }),
  ),
};
