import PropTypes from 'prop-types';
import { BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid, ResponsiveContainer } from 'recharts';

export default function SkillLevelHistogram({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { level: 1, count: 3 },
        { level: 2, count: 6 },
        { level: 3, count: 12 },
        { level: 4, count: 9 },
        { level: 5, count: 5 },
      ];

  const axisColor = 'var(--text-color-secondary)';
  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Skill Level Histogram</h3>
      <ResponsiveContainer width="100%" height={240}>
        <BarChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis
            dataKey="level"
            tick={{ fill: axisColor }}
            label={{ value: 'Level', position: 'insideBottom', dy: 10, fill: axisColor }}
          />
          <YAxis
            tick={{ fill: axisColor }}
            label={{ value: 'Count', angle: -90, position: 'insideLeft', dx: -10, fill: axisColor }}
          />
          <Tooltip contentStyle={tooltipStyle} />
          <Bar dataKey="count" fill="#6366f1" radius={[4, 4, 0, 0]} />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}

SkillLevelHistogram.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      level: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
      count: PropTypes.number.isRequired,
    }),
  ),
};
