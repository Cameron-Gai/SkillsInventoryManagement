import PropTypes from 'prop-types';
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, Legend } from 'recharts';

export default function RecentActivityLineChart({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { day: 'Mon', changes: 5 },
        { day: 'Tue', changes: 8 },
        { day: 'Wed', changes: 6 },
        { day: 'Thu', changes: 9 },
        { day: 'Fri', changes: 4 },
      ];

  const axisColor = 'var(--text-color-secondary)';
  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Recent Activity</h3>
      <ResponsiveContainer width="100%" height={240}>
        <LineChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="day" tick={{ fill: axisColor }} />
          <YAxis tick={{ fill: axisColor }} />
          <Tooltip contentStyle={tooltipStyle} />
          <Legend />
          <Line type="monotone" dataKey="changes" name="Skill Changes" stroke="#10b981" strokeWidth={3} dot />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

RecentActivityLineChart.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      day: PropTypes.string.isRequired,
      changes: PropTypes.number.isRequired,
    }),
  ),
};
