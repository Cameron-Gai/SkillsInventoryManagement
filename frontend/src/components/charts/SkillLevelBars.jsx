import PropTypes from 'prop-types';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, LabelList } from 'recharts';

export default function SkillLevelBars({ data = [], maxLevel = 5, barColor = '#3182ce' }) {
  const chartData = data.length
    ? data
    : [
        { skill: 'React', level: 4 },
        { skill: 'Node', level: 3 },
        { skill: 'SQL', level: 5 },
        { skill: 'Design', level: 2 },
      ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4 space-y-2">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">Skill Levels</h3>
        <span className="text-sm text-gray-500 dark:text-gray-400">Max {maxLevel}</span>
      </div>
      <ResponsiveContainer width="100%" height={300}>
        <BarChart data={chartData} layout="vertical" margin={{ left: 24 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="var(--grid-color, #e2e8f0)" />
          <XAxis type="number" domain={[0, maxLevel]} hide />
          <YAxis dataKey="skill" type="category" tick={{ fill: '#6b7280' }} width={100} />
          <Tooltip labelStyle={{ color: '#111827' }} formatter={(value) => [`Level ${value}`, '']} />
          <Bar dataKey="level" fill={barColor} radius={[4, 4, 4, 4]}>
            <LabelList dataKey="level" position="right" fill="#1f2937" />
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

SkillLevelBars.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      skill: PropTypes.string.isRequired,
      level: PropTypes.number.isRequired,
    }),
  ),
  maxLevel: PropTypes.number,
  barColor: PropTypes.string,
};
