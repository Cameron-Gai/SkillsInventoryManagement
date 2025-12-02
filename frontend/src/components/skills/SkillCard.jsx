import PendingBadge from './PendingBadge'

const LEVEL_BADGE_COLORS = {
  beginner: 'bg-sky-100 text-sky-800 border-sky-200',
  intermediate: 'bg-indigo-100 text-indigo-800 border-indigo-200',
  advanced: 'bg-purple-100 text-purple-800 border-purple-200',
  expert: 'bg-emerald-100 text-emerald-800 border-emerald-200',
  default: 'bg-[color:var(--color-primary)] text-[color:var(--text-color-contrast)] border-transparent',
}

export default function SkillCard({ skill, onEdit }) {
  const normalizedLevel = skill.level?.toLowerCase?.()
  const badgeColors = LEVEL_BADGE_COLORS[normalizedLevel] || LEVEL_BADGE_COLORS.default

  return (
    <div className="flex h-full flex-col rounded-lg border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-start justify-between gap-3">
        <div className="space-y-1">
          <h4 className="text-lg font-semibold text-[var(--text-color)]">{skill.name}</h4>
          <p className="text-sm text-[var(--text-color-secondary)]">{skill.category}</p>
        </div>
        <div className="flex flex-col items-end gap-2">
          <span className={`rounded-full border px-2.5 py-0.5 text-xs font-semibold uppercase tracking-wide ${badgeColors}`}>
            {skill.level}
          </span>
          <PendingBadge status={skill.status} />
        </div>
      </div>

      {skill.notes && (
        <p className="mt-3 text-sm text-[var(--text-color-secondary)]">{skill.notes}</p>
      )}

      <div className="mt-auto flex items-end justify-between gap-3 pt-4">
        <div className="text-xs text-[var(--text-color-secondary)] space-y-1">
          <div className="rounded-md bg-[var(--background-muted)] px-2 py-1 font-medium">Years: {skill.years}</div>
          <div className="rounded-md bg-[var(--background-muted)] px-2 py-1 font-medium">Usage: {skill.frequency}</div>
        </div>
        <button
          type="button"
          onClick={() => onEdit(skill)}
          className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm font-medium text-[var(--text-color)] transition hover:border-[color:var(--color-primary)] hover:text-[color:var(--color-primary)]"
        >
          Edit
        </button>
      </div>
    </div>
  )
}
