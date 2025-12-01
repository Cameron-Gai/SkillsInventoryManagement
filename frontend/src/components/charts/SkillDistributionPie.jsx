import PropTypes from 'prop-types';
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts';

const COLORS = ['#3182ce', '#805ad5', '#38a169', '#d69e2e', '#f97316', '#ec4899'];

export default function SkillDistributionPie({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { name: 'Frontend', value: 16 },
        { name: 'Backend', value: 12 },
        { name: 'Data', value: 8 },
        { name: 'DevOps', value: 6 },
      ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">Skill Distribution</h3>
      <ResponsiveContainer width="100%" height={260}>
        <PieChart>
          <Pie data={chartData} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={90} label>
            {chartData.map((entry, index) => (
              <Cell key={`cell-${entry.name}`} fill={COLORS[index % COLORS.length]} />
            ))}
          </Pie>
          <Tooltip />
          <Legend />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
}

SkillDistributionPie.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string.isRequired,
      value: PropTypes.number.isRequired,
    }),
  ),
};
