import PendingBadge from './PendingBadge'

function levelClasses(level) {
  switch ((level || '').toLowerCase()) {
    case 'beginner':
      return 'bg-[color:var(--level-beginner-bg)] text-[color:var(--level-beginner-fg)]'
    case 'intermediate':
      return 'bg-[color:var(--level-intermediate-bg)] text-[color:var(--level-intermediate-fg)]'
    case 'advanced':
      return 'bg-[color:var(--level-advanced-bg)] text-[color:var(--level-advanced-fg)]'
    case 'expert':
      return 'bg-[color:var(--level-expert-bg)] text-[color:var(--level-expert-fg)]'
    default:
      return 'bg-[color:var(--background)] text-[color:var(--text-color)]'
  }
}

function isHighValue(skill) {
  const tech = (skill.type || '').toLowerCase() === 'technology'
  const highLevel = (skill.level || '').toLowerCase() === 'expert'
  const freq = (skill.frequency || '').toLowerCase()
  const often = freq === 'daily' || freq === 'weekly'
  return tech && highLevel && often
}

function computeFitScore(skill) {
  const levelMap = { beginner: 1, intermediate: 2, advanced: 3, expert: 4 }
  const freqMap = { daily: 1.0, weekly: 0.8, monthly: 0.5, occasionally: 0.3 }
  const lvl = levelMap[(skill.level || '').toLowerCase()] || 1
  const freq = freqMap[(skill.frequency || '').toLowerCase()] || 0.5
  const years = Number(skill.years || 0)
  const yearsFactor = Math.min(1, years / 5)
  const score = Math.round(lvl * 25 + freq * 25 + yearsFactor * 50)
  return Math.max(0, Math.min(100, score))
}

export default function SkillCard({ skill, onEdit, onDelete }) {
  const levelBadgeClass = levelClasses(skill.level)
  const highValue = isHighValue(skill)

  return (
    <div className="rounded-lg border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-start justify-between gap-3">
        <div>
          <div className="flex items-center gap-3">
            <h4 className="text-lg font-semibold text-[var(--text-color)]">{skill.name}</h4>
            <PendingBadge status={skill.status} />
            {highValue && (
              <span className="inline-flex items-center rounded-full bg-amber-200 text-amber-800 dark:bg-amber-900 dark:text-amber-200 px-2 py-0.5 text-xs font-semibold">
                High-Value
              </span>
            )}
          </div>
          <p className="text-sm text-[var(--text-color-secondary)]">{skill.category}</p>
        </div>
        <span className={`text-xs font-semibold rounded-full px-3 py-1 ${levelBadgeClass}`}>
          {skill.level}
        </span>
      </div>

      {skill.notes && (
        <p className="mt-3 text-sm text-[var(--text-color-secondary)]">{skill.notes}</p>
      )}

      <div className="mt-4 flex items-end justify-between">
        <div className="text-xs text-[var(--text-color-secondary)] space-y-1">
          <div className="rounded-md bg-[var(--background-muted)] px-2 py-1 font-medium">Years: {skill.years}</div>
          <div className="rounded-md bg-[var(--background-muted)] px-2 py-1 font-medium">Usage: {skill.frequency}</div>
        </div>
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => onEdit && onEdit(skill)}
            className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm font-medium text-[var(--text-color)] transition hover:border-[color:var(--color-primary)] hover:text-[color:var(--color-primary)]"
          >
            Edit
          </button>
        </div>
      </div>
    </div>
  )
}
