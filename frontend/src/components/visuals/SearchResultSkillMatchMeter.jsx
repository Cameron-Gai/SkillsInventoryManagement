import PropTypes from 'prop-types';

export default function SearchResultSkillMatchMeter({ match = 0, label = 'Skill Match', variant = 'card' }) {
  const value = Math.min(Math.max(match, 0), 100);
  const gradient = value > 75 ? 'from-emerald-400 to-emerald-600' : value > 50 ? 'from-amber-400 to-amber-500' : 'from-rose-400 to-rose-500';
  const isInline = variant === 'inline';
  const containerClass = isInline
    ? 'space-y-2'
    : 'rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm';

  return (
    <div className={containerClass}>
      <div className="flex items-center justify-between mb-2">
        <p className="text-sm font-semibold text-[var(--text-color)]">{label}</p>
        <span className="text-sm text-[var(--text-color-secondary)]">{value}%</span>
      </div>
      <div className="w-full h-3 rounded-full overflow-hidden border border-[var(--border-color)] bg-[var(--background-muted)]">
        <div className={`h-full bg-gradient-to-r ${gradient}`} style={{ width: `${value}%` }} />
      </div>
      <p className="text-xs text-[var(--text-color-secondary)] mt-2">
        Higher values indicate stronger alignment to required skills.
      </p>
    </div>
  );
}

SearchResultSkillMatchMeter.propTypes = {
  match: PropTypes.number,
  label: PropTypes.string,
  variant: PropTypes.oneOf(['card', 'inline']),
};
