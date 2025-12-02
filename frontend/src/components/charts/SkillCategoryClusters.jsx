import PropTypes from 'prop-types';
import { Treemap, ResponsiveContainer, Tooltip } from 'recharts';

const colors = ['#3182ce', '#805ad5', '#38a169', '#d69e2e', '#e53e3e', '#718096'];

function CustomTooltip({ active, payload }) {
  if (!active || !payload?.length) return null;
  const { name, value } = payload[0];
  return (
    <div className="rounded border border-[var(--border-color)] bg-[var(--card-background)] px-3 py-2 text-sm shadow-sm">
      <p className="font-semibold text-[var(--text-color)]">{name}</p>
      <p className="text-[var(--text-color-secondary)]">{value} skills</p>
    </div>
  );
}

CustomTooltip.propTypes = {
  active: PropTypes.bool,
  payload: PropTypes.array,
};

export default function SkillCategoryClusters({ data = [] }) {
  const chartData = data.length
    ? data
    : [
        { name: 'Frontend', size: 8 },
        { name: 'Backend', size: 6 },
        { name: 'Data', size: 4 },
        { name: 'DevOps', size: 3 },
        { name: 'Design', size: 5 },
      ];

  const formatted = chartData.map((item, idx) => ({ ...item, fill: colors[idx % colors.length] }));

  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-lg font-semibold text-[var(--text-color)]">Skill Category Clusters</h3>
        <span className="text-sm text-[var(--text-color-secondary)]">Hover for counts</span>
      </div>
      <ResponsiveContainer width="100%" height={280}>
        <Treemap data={formatted} dataKey="size" stroke="#f7fafc" fill="#3182ce">
          <Tooltip content={<CustomTooltip />} />
        </Treemap>
      </ResponsiveContainer>
    </div>
  );
}

SkillCategoryClusters.propTypes = {
  data: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string.isRequired,
      size: PropTypes.number.isRequired,
    }),
  ),
};
