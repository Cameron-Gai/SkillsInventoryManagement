import PropTypes from 'prop-types'

const toNumber = (value) => {
  if (value === null || value === undefined) return null
  const parsed = Number(value)
  return Number.isFinite(parsed) ? parsed : null
}

const toPercent = (value) => {
  const num = toNumber(value)
  return num === null ? null : Math.round(num * 100)
}

export default function DesirableNote({ skill, className = '' }) {
  if (!skill) return null

  const teamCount = toNumber(skill.team_count)
  const teamCoveragePct = toPercent(skill.team_coverage)
  const employeePct = toPercent(skill.employee_penetration)
  const approvedEmployees = toNumber(skill.approved_employees)

  const hasFocusStats =
    teamCount !== null || teamCoveragePct !== null || employeePct !== null || approvedEmployees !== null

  if (hasFocusStats) {
    return (
      <div className={`text-xs text-[var(--text-color-secondary)] space-y-0.5 ${className}`.trim()}>
        <p>
          {teamCount !== null ? `${teamCount} manager${teamCount === 1 ? '' : 's'}` : 'Managers'}
          {teamCoveragePct !== null ? ` (${teamCoveragePct}%)` : ''} marked this as desirable
        </p>
        {employeePct !== null && (
          <p>
            {employeePct}% of employees
            {approvedEmployees !== null ? ` (about ${approvedEmployees})` : ''}
            {' '}have this skill
          </p>
        )}
      </div>
    )
  }

  if (!skill.notes) return null

  return (
    <p className={`text-xs text-[var(--text-color-secondary)] ${className}`.trim()}>{skill.notes}</p>
  )
}

DesirableNote.propTypes = {
  skill: PropTypes.shape({
    team_count: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    team_coverage: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    employee_penetration: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    approved_employees: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    notes: PropTypes.string,
  }),
  className: PropTypes.string,
}
