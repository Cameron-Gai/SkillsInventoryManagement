import PropTypes from 'prop-types';
import { ComposedChart, Line, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts';

export default function AuditLogTimelineChart({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { day: 'Mon', audits: 12, anomalies: 1 },
        { day: 'Tue', audits: 9, anomalies: 0 },
        { day: 'Wed', audits: 14, anomalies: 2 },
        { day: 'Thu', audits: 11, anomalies: 1 },
        { day: 'Fri', audits: 16, anomalies: 3 },
      ];

  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">Audit Log Timeline</h3>
      <ResponsiveContainer width="100%" height={260}>
        <ComposedChart data={chartData} margin={{ top: 10, right: 20, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="day" tick={{ fill: '#6b7280' }} />
          <YAxis tick={{ fill: '#6b7280' }} />
          <Tooltip />
          <Legend />
          <Bar dataKey="audits" name="Entries" fill="#3b82f6" radius={[4, 4, 0, 0]} />
          <Line dataKey="anomalies" name="Alerts" stroke="#ef4444" strokeWidth={3} dot />
        </ComposedChart>
      </ResponsiveContainer>
    </div>
  );
}

AuditLogTimelineChart.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      day: PropTypes.string.isRequired,
      audits: PropTypes.number.isRequired,
      anomalies: PropTypes.number.isRequired,
    }),
  ),
};
