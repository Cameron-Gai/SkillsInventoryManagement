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

  const axisColor = 'var(--text-color-secondary)';
  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Skill Proximity</h3>
      <ResponsiveContainer width="100%" height={300}>
        <RadarChart data={chartData} cx="50%" cy="50%" outerRadius="70%">
          <PolarGrid />
          <PolarAngleAxis dataKey="skill" tick={{ fill: axisColor }} />
          <PolarRadiusAxis angle={30} domain={[0, 100]} tick={{ fill: axisColor }} />
          <Radar name="Match" dataKey="proximity" stroke="#6366f1" fill="#6366f1" fillOpacity={0.5} />
          <Tooltip formatter={(value) => `${value}% overlap`} contentStyle={tooltipStyle} />
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
