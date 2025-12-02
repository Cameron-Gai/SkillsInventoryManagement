import PropTypes from 'prop-types';
import { RadialBarChart, RadialBar, Legend, Tooltip, ResponsiveContainer } from 'recharts';

const COLORS = ['#2563eb', '#10b981', '#f59e0b', '#f43f5e', '#8b5cf6'];

export default function TeamSkillProfileWheel({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { name: 'Frontend', value: 24, fill: COLORS[0] },
        { name: 'Backend', value: 20, fill: COLORS[1] },
        { name: 'Data', value: 16, fill: COLORS[2] },
        { name: 'DevOps', value: 12, fill: COLORS[3] },
        { name: 'Security', value: 8, fill: COLORS[4] },
      ];

  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Team Skill Profile Wheel</h3>
      <ResponsiveContainer width="100%" height={320}>
        <RadialBarChart cx="50%" cy="50%" innerRadius="20%" outerRadius="90%" barSize={14} data={chartData}>
          <RadialBar background dataKey="value" cornerRadius={8} />
          <Legend iconType="circle" />
          <Tooltip contentStyle={tooltipStyle} />
        </RadialBarChart>
      </ResponsiveContainer>
    </div>
  );
}

TeamSkillProfileWheel.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string.isRequired,
      value: PropTypes.number.isRequired,
      fill: PropTypes.string,
    }),
  ),
};
