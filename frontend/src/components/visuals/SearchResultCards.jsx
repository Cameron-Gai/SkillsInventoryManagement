import PropTypes from 'prop-types'
import StatusBadges from './StatusBadges'

const getTimestamp = (value) => {
  if (!value && value !== 0) return null
  if (typeof value === 'number') return value
  const ms = new Date(value).getTime()
  return Number.isNaN(ms) ? null : ms
}

const formatRelativeTime = (value) => {
  const timestamp = getTimestamp(value)
  if (timestamp === null) return 'Timestamp unavailable'

  const diffMs = Date.now() - timestamp
  if (diffMs < 0) return 'Just now'

  const minute = 60 * 1000
  const hour = 60 * minute
  const day = 24 * hour
  const week = 7 * day

  if (diffMs < minute) {
    const seconds = Math.max(1, Math.floor(diffMs / 1000))
    return `${seconds}s ago`
  }
  if (diffMs < hour) {
    const minutes = Math.floor(diffMs / minute)
    return `${minutes}m ago`
  }
  if (diffMs < day) {
    const hours = Math.floor(diffMs / hour)
    return `${hours}h ago`
  }
  if (diffMs < week) {
    const days = Math.floor(diffMs / day)
    return `${days}d ago`
  }
  const weeks = Math.floor(diffMs / week)
  return `${weeks}w ago`
}

const sortSkillsByRequestAge = (skills = []) => {
  return [...skills].sort((a, b) => {
    const aTime = getTimestamp(a?.requestedAt)
    const bTime = getTimestamp(b?.requestedAt)
    const safeA = aTime ?? Number.POSITIVE_INFINITY
    const safeB = bTime ?? Number.POSITIVE_INFINITY

    if (safeA !== safeB) return safeA - safeB
    const aName = a?.name || ''
    const bName = b?.name || ''
    return aName.localeCompare(bName)
  })
}

const stripTrailingAgo = (label) => (typeof label === 'string' ? label.replace(/\sago$/, '') : label)
const buildActionKey = (item, skill) => `${item.id ?? item.person_id ?? item.username ?? item.name}-${skill.id ?? skill.skill_id ?? skill.name}`

const fallbackResults = [
  {
    id: 'sample-1',
    name: 'Alex Johnson',
    role: 'Frontend Engineer',
    status: 'pending',
    waitTimestamp: Date.now() - 1000 * 60 * 60 * 24 * 4,
    skills: [
      {
        id: 'react',
        name: 'React',
        type: 'Technology',
        requestedAt: Date.now() - 1000 * 60 * 60 * 20,
        proficiencyLevel: 'Intermediate',
        usageFrequency: 'Daily',
        experienceYears: 3,
        notes: 'Needs production access',
      },
    ],
  },
]

export default function SearchResultCards({ results = [], onResolveSkill, pendingActionKey }) {
  const data = results.length ? results : fallbackResults

  return (
    <div className="space-y-3">
      {data.map((item) => (
        <div
          key={item.id ?? item.name}
          className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm space-y-4"
        >
          <div className="flex items-start justify-between gap-4">
            <div>
              <h4 className="text-lg font-semibold text-[var(--text-color)]">{item.name}</h4>
              <p className="text-sm text-[var(--text-color-secondary)]">{item.role || 'Employee'}</p>
              <p className="text-xs text-[var(--text-color-secondary)]">
                {item.pendingCount ?? item.skills?.length ?? 0} {item.pendingLabel || 'pending request(s)'}
              </p>
            </div>
            <div className="text-right space-y-1">
              <StatusBadges status={item.status || 'pending'} />
              <p className="text-xs text-[var(--text-color-secondary)]">
                {(item.waitLabel || 'Waiting')} {item.waitText || stripTrailingAgo(formatRelativeTime(item.waitTimestamp))}
              </p>
            </div>
          </div>

          <div className="space-y-2">
            {sortSkillsByRequestAge(item.skills)?.map((skill) => {
              const normalizedStatus = (skill.status ?? '').toLowerCase()
              const canResolve = typeof onResolveSkill === 'function' && ['pending', 'requested'].includes(normalizedStatus)
              const actionKey = buildActionKey(item, skill)
              const busy = pendingActionKey === actionKey

              return (
                <div
                  key={skill.id ?? `${item.id}-${skill.name}`}
                  className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3"
                >
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <p className="text-sm font-medium text-[var(--text-color)]">{skill.name}</p>
                    <p className="text-xs text-[var(--text-color-secondary)]">{skill.type || 'Skill'}</p>
                  </div>
                  <div className="text-right space-y-1">
                    {skill.status?.toLowerCase?.() === 'pending' && (
                      <span className="inline-flex items-center rounded-full border border-[var(--accent-warning-border)] bg-[var(--accent-warning-bg)] px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wide text-[var(--accent-warning-text)]">
                        Pending skill
                      </span>
                    )}
                    {skill.requestedAt && (
                      <p className="text-xs text-[var(--text-color-secondary)]">Pending since {formatRelativeTime(skill.requestedAt)}</p>
                    )}
                  </div>
                </div>
                <div className="mt-2 flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--text-color-secondary)]">
                  <span>Proficiency: {skill.proficiencyLevel || 'Not specified'}</span>
                  <span>Usage: {skill.usageFrequency || 'Not specified'}</span>
                  <span>Experience: {typeof skill.experienceYears === 'number' ? `${skill.experienceYears} yr${skill.experienceYears === 1 ? '' : 's'}` : 'Not specified'}</span>
                </div>
                {skill.notes && (
                  <p className="mt-2 text-xs italic text-[var(--text-color-secondary)]">Notes: {skill.notes}</p>
                )}
                {canResolve && (
                  <div className="mt-3 flex flex-wrap gap-2">
                    {['Approved', 'Canceled'].map((nextStatus) => {
                      const isApprove = nextStatus === 'Approved'
                      return (
                        <button
                          key={`${actionKey}-${nextStatus}`}
                          type="button"
                          disabled={busy}
                          onClick={() => onResolveSkill(item, skill, nextStatus)}
                          className={`rounded-md border px-3 py-1 text-xs font-semibold transition ${
                            isApprove
                              ? 'border-emerald-200 bg-emerald-50 text-emerald-700 hover:bg-emerald-100'
                              : 'border-rose-200 bg-rose-50 text-rose-700 hover:bg-rose-100'
                          } ${busy ? 'opacity-60' : ''}`}
                        >
                          {busy ? 'Saving...' : isApprove ? 'Approve' : 'Reject'}
                        </button>
                      )
                    })}
                  </div>
                )}
                </div>
              )
            })}
          </div>
        </div>
      ))}
    </div>
  )
}

SearchResultCards.propTypes = {
  results: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
      name: PropTypes.string.isRequired,
      role: PropTypes.string,
      status: PropTypes.string,
      waitTimestamp: PropTypes.oneOfType([PropTypes.string, PropTypes.number, PropTypes.instanceOf(Date)]),
      waitLabel: PropTypes.string,
      waitText: PropTypes.string,
      skills: PropTypes.arrayOf(
        PropTypes.shape({
          id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
          name: PropTypes.string.isRequired,
          type: PropTypes.string,
          requestedAt: PropTypes.oneOfType([PropTypes.string, PropTypes.number, PropTypes.instanceOf(Date)]),
          proficiencyLevel: PropTypes.string,
          usageFrequency: PropTypes.string,
          experienceYears: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
          notes: PropTypes.string,
        }),
      ),
      pendingCount: PropTypes.number,
      pendingLabel: PropTypes.string,
    }),
  ),
  onResolveSkill: PropTypes.func,
  pendingActionKey: PropTypes.string,
}
