import PropTypes from 'prop-types';
import { Area, AreaChart, ResponsiveContainer, XAxis, YAxis, Tooltip, CartesianGrid } from 'recharts';

export default function SkillChangeTimeline({ data = [], stroke = '#2563eb', fill = '#bfdbfe' }) {
  const chartData = data.length
    ? data
    : [
        { month: 'Jan', additions: 6, removals: 1 },
        { month: 'Feb', additions: 4, removals: 2 },
        { month: 'Mar', additions: 7, removals: 1 },
        { month: 'Apr', additions: 5, removals: 3 },
        { month: 'May', additions: 9, removals: 2 },
      ];

  const axisColor = 'var(--text-color-secondary)';
  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm space-y-3">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold text-[var(--text-color)]">Skill Change Timeline</h3>
        <span className="text-sm text-[var(--text-color-secondary)]">Monthly adds vs drops</span>
      </div>
      <ResponsiveContainer width="100%" height={260}>
        <AreaChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="month" tick={{ fill: axisColor }} />
          <YAxis tick={{ fill: axisColor }} />
          <Tooltip contentStyle={tooltipStyle} />
          <Area type="monotone" dataKey="additions" name="Added" stroke={stroke} fill={fill} strokeWidth={2} />
          <Area
            type="monotone"
            dataKey="removals"
            name="Removed"
            stroke="#f97316"
            fill="#fed7aa"
            strokeWidth={2}
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}

SkillChangeTimeline.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      month: PropTypes.string.isRequired,
      additions: PropTypes.number.isRequired,
      removals: PropTypes.number.isRequired,
    }),
  ),
  stroke: PropTypes.string,
  fill: PropTypes.string,
};
