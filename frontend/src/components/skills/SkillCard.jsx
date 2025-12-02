import PendingBadge from './PendingBadge'

export default function SkillCard({ skill, onEdit, onDelete }) {
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
        <span className="text-xs font-semibold rounded-full px-3 py-1 bg-[color:var(--color-primary)] text-[color:var(--text-color-contrast)]">
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
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => onEdit && skill.status !== 'Approved' && onEdit(skill)}
            disabled={skill.status === 'Approved'}
            className={`rounded-md border px-3 py-1.5 text-sm font-medium transition ${
              skill.status === 'Approved'
                ? 'border-[var(--border-color)] text-[var(--text-color-secondary)] cursor-not-allowed opacity-60'
                : 'border-[var(--border-color)] text-[var(--text-color)] hover:border-[color:var(--color-primary)] hover:text-[color:var(--color-primary)]'
            }`}
          >
            Edit
          </button>
          {skill.status === 'Requested' && onDelete && (
            <button
              type="button"
              onClick={() => onDelete(skill.id)}
              className="rounded-md border border-red-300 px-3 py-1.5 text-sm font-medium text-red-600 transition hover:bg-red-50 hover:border-red-500"
            >
              Delete
            </button>
          )}
        </div>
      </div>
    </div>
  )
}
