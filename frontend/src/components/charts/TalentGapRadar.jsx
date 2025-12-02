import PropTypes from 'prop-types';
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer, Legend, Tooltip } from 'recharts';

export default function TalentGapRadar({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { category: 'Frontend', current: 7, target: 9 },
        { category: 'Backend', current: 6, target: 8 },
        { category: 'Data', current: 5, target: 7 },
        { category: 'DevOps', current: 4, target: 7 },
        { category: 'Security', current: 3, target: 6 },
      ];

  const tickColor = 'var(--text-color-secondary)';
  const tooltipStyle = {
    backgroundColor: 'var(--card-background)',
    border: '1px solid var(--border-color)',
    color: 'var(--text-color)',
  };

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <h3 className="text-lg font-semibold text-[var(--text-color)] mb-3">Talent Gap Radar</h3>
      <ResponsiveContainer width="100%" height={320}>
        <RadarChart data={chartData} cx="50%" cy="50%" outerRadius="70%">
          <PolarGrid />
          <PolarAngleAxis dataKey="category" tick={{ fill: tickColor }} />
          <PolarRadiusAxis angle={30} domain={[0, 10]} tick={{ fill: tickColor }} />
          <Radar name="Current" dataKey="current" stroke="#0ea5e9" fill="#0ea5e9" fillOpacity={0.5} />
          <Radar name="Target" dataKey="target" stroke="#f97316" fill="#f97316" fillOpacity={0.3} />
          <Legend />
          <Tooltip contentStyle={tooltipStyle} />
        </RadarChart>
      </ResponsiveContainer>
    </div>
  );
}

TalentGapRadar.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      category: PropTypes.string.isRequired,
      current: PropTypes.number.isRequired,
      target: PropTypes.number.isRequired,
    }),
  ),
};
