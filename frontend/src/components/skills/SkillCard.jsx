import PendingBadge from './PendingBadge'

export default function SkillCard({ skill, onEdit }) {
  return (
    <div className="rounded-lg border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-start justify-between gap-3">
        <div>
          <div className="flex items-center gap-3">
            <h4 className="text-lg font-semibold text-[var(--text-color)]">{skill.name}</h4>
            <PendingBadge status={skill.status} />
          </div>
          <p className="text-sm text-[var(--text-color-secondary)]">{skill.category}</p>
        </div>
        <span className="rounded-full bg-[color:var(--color-primary)]/10 px-3 py-1 text-xs font-semibold text-[color:var(--color-primary)]">
          {skill.level}
        </span>
      </div>

      {skill.notes && (
        <p className="mt-3 text-sm text-[var(--text-color-secondary)]">{skill.notes}</p>
      )}

      <div className="mt-4 flex flex-wrap items-center justify-between gap-3">
        <div className="flex flex-wrap gap-2 text-xs text-[var(--text-color-secondary)]">
          <span className="rounded-full bg-[var(--background)] px-2 py-1">Years: {skill.years}</span>
          <span className="rounded-full bg-[var(--background)] px-2 py-1">Usage: {skill.frequency}</span>
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
