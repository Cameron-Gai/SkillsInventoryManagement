// Team.jsx
// Manager dashboard for viewing and managing team members.

import { useState, useEffect, useMemo, useCallback } from 'react'
import Sidebar from '@/components/Sidebar'
import ApprovalQueuePriorityIndicator from '@/components/visuals/ApprovalQueuePriorityIndicator'
import DataVolumeCounters from '@/components/visuals/DataVolumeCounters'
import SearchResultCards from '@/components/visuals/SearchResultCards'
import teamApi from '@/api/teamApi'
import skillsApi from '@/api/skillsApi'

const normalizePendingSkills = (member) => {
  const rawSkills = Array.isArray(member?.pending_skills_detail)
    ? member.pending_skills_detail
    : Array.isArray(member?.pending_skills)
      ? member.pending_skills
      : []

  return rawSkills
    .map((skill) => {
      if (!skill) return null
      if (typeof skill === 'string') {
        return {
          id: `skill-${Math.random().toString(36).slice(2)}`,
          name: skill,
          type: 'Skill request',
          requestedAt: null,
          proficiencyLevel: null,
          usageFrequency: null,
          experienceYears: null,
          status: 'pending',
          notes: '',
        }
      }

      const requestedAt = skill.requested_at ?? skill.requestedAt ?? null
      const experienceValue = skill.experience_years ?? skill.experienceYears ?? null
      let experienceYears = null
      if (experienceValue !== null && experienceValue !== undefined && experienceValue !== '') {
        const parsed = typeof experienceValue === 'number' ? experienceValue : Number(experienceValue)
        experienceYears = Number.isNaN(parsed) ? null : parsed
      }

      return {
        id: skill.skill_id ?? skill.skillId ?? skill.id ?? skill.name ?? `skill-${Math.random().toString(36).slice(2)}`,
        name: skill.name ?? skill.skill_name ?? 'Skill request',
        type: skill.type ?? skill.skill_type ?? 'Skill',
        requestedAt,
        proficiencyLevel: skill.proficiency_level ?? skill.proficiencyLevel ?? null,
        usageFrequency: skill.usage_frequency ?? skill.usageFrequency ?? null,
        experienceYears,
        status: skill.status ?? skill.review_status ?? skill.state ?? 'Pending',
        notes: skill.notes ?? skill.note ?? '',
      }
    })
    .filter(Boolean)
}

const describeFitStatus = (score) => {
  if (score >= 85) return 'great'
  if (score >= 70) return 'good'
  if (score >= 55) return 'okay'
  return 'needs_work'
}

export default function Team() {
  const [teamMembers, setTeamMembers] = useState([])
  const [insights, setInsights] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [selectedMember, setSelectedMember] = useState(null)
  const [memberDetails, setMemberDetails] = useState(null)
  const [highValueSkills, setHighValueSkills] = useState([])
  const [skillOptions, setSkillOptions] = useState([])
  const [highValueForm, setHighValueForm] = useState({ skill_id: '', priority: 'High', notes: '' })
  const [highValueError, setHighValueError] = useState(null)
  const [highValueLoading, setHighValueLoading] = useState(false)
  const [reviewActionKey, setReviewActionKey] = useState(null)
  const [reviewActionError, setReviewActionError] = useState(null)

  const fetchTeamData = useCallback(async ({ withLoader = true } = {}) => {
    try {
      if (withLoader) {
        setLoading(true)
        setError(null)
      }

      const [teamRes, insightsRes, highValueRes, skillsRes] = await Promise.all([
        teamApi.getMyTeam(),
        teamApi.getTeamInsights(),
        teamApi.getHighValueSkills(),
        skillsApi.getAllSkills(),
      ])

      setTeamMembers(teamRes.data || [])
      setInsights(insightsRes.data)
      setHighValueSkills(highValueRes.data || [])
      setSkillOptions(skillsRes.data || [])
    } catch (err) {
      if (withLoader) {
        setError('Failed to load team data: ' + err.message)
      }
      console.error('Error:', err)
      if (!withLoader) {
        throw err
      }
    } finally {
      if (withLoader) {
        setLoading(false)
      }
    }
  }, [])

  useEffect(() => {
    fetchTeamData()
  }, [fetchTeamData])

  const handleSelectMember = async (memberId) => {
    try {
      const response = await teamApi.getTeamMember(memberId)
      setSelectedMember(memberId)
      setMemberDetails(response.data)
    } catch (err) {
      setError('Failed to load member details: ' + err.message)
    }
  }

  const pendingReviewTotal = useMemo(() => {
    if (!teamMembers?.length) {
      return insights?.pending_approvals ?? 0
    }

    return teamMembers.reduce((total, member) => total + normalizePendingSkills(member).length, 0)
  }, [teamMembers, insights?.pending_approvals])

  const overviewCounts = useMemo(() => ({
    skills: insights?.unique_skills ?? insights?.team_skill_count ?? 0,
    employees: teamMembers?.length ?? 0,
    teams: insights?.active_projects ?? 1,
    audits: pendingReviewTotal,
  }), [insights, teamMembers, pendingReviewTotal])

  const approvalLatencyBuckets = useMemo(() => {
    if (!teamMembers?.length) {
      const pending = insights?.pending_approvals ?? 0
      return {
        overWeek: Math.round(pending * 0.25),
        overThree: Math.round(pending * 0.35),
        underThree: Math.max(0, pending - Math.round(pending * 0.6)),
      }
    }

    const now = Date.now()
    return teamMembers.reduce((buckets, member) => {
      normalizePendingSkills(member).forEach((skill) => {
        const requestedAt = skill.requestedAt ? new Date(skill.requestedAt).getTime() : null
        if (!requestedAt || Number.isNaN(requestedAt)) {
          buckets.underThree += 1
          return
        }

        const ageDays = (now - requestedAt) / (1000 * 60 * 60 * 24)
        if (ageDays > 7) {
          buckets.overWeek += 1
        } else if (ageDays > 3) {
          buckets.overThree += 1
        } else {
          buckets.underThree += 1
        }
      })
      return buckets
    }, { overWeek: 0, overThree: 0, underThree: 0 })
  }, [teamMembers, insights?.pending_approvals])

  const skillNameLookup = useMemo(() => {
    const lookup = new Map()
    skillOptions.forEach((skill) => {
      if (skill?.id) {
        lookup.set(skill.id, skill.name)
      }
    })
    return lookup
  }, [skillOptions])

  const spotlightMatches = useMemo(() => {
    const priorityWeights = { High: 3, Medium: 2, Low: 1 }
    const proficiencyWeights = { expert: 1, advanced: 0.85, intermediate: 0.65, beginner: 0.4 }

    const prioritizedSkills = (highValueSkills || [])
      .map((skill) => {
        const label = skill.skill_name ?? skillNameLookup.get(skill.skill_id) ?? skill.name
        const key = typeof label === 'string' ? label.trim().toLowerCase() : ''
        if (!key) return null
        return {
          ...skill,
          label,
          key,
          weight: priorityWeights[skill.priority] ?? 1.5,
        }
      })
      .filter(Boolean)

    if (prioritizedSkills.length && teamMembers.length) {
      const maxScore = prioritizedSkills.reduce((sum, skill) => sum + skill.weight, 0)
      if (maxScore > 0) {
        // Score each team member against the defined priorities using weighted proficiency.
        const matches = teamMembers
          .map((member) => {
            const profile = new Map()

            const registerSkill = (label, payload = {}) => {
              const key = typeof label === 'string' ? label.trim().toLowerCase() : ''
              if (!key) return

              const normalizedLevel = payload.proficiencyLevel?.toLowerCase?.() || 'intermediate'
              const experienceYears = typeof payload.experienceYears === 'number' ? payload.experienceYears : null
              const source = payload.source || 'pending'
              const statusValue = payload.status || 'pending'
              const baseScore = proficiencyWeights[normalizedLevel] ?? 0.55
              const experienceBoost = typeof experienceYears === 'number' ? Math.min(experienceYears / 10, 0.25) : 0
              const statusLower = statusValue?.toLowerCase?.() ?? 'pending'
              const statusBoost = statusLower === 'approved' ? 0.15 : statusLower === 'rejected' ? -0.1 : 0
              const proficiencyScore = Math.max(0.25, Math.min(1, baseScore + experienceBoost + statusBoost))

              const record = {
                name: label,
                proficiencyLevel: payload.proficiencyLevel || 'Not specified',
                experienceYears,
                usageFrequency: payload.usageFrequency ?? null,
                requestedAt: payload.requestedAt ?? null,
                status: statusValue,
                source,
                proficiencyScore,
              }

              const existing = profile.get(key)
              if (!existing || proficiencyScore > existing.proficiencyScore) {
                profile.set(key, record)
              }
            }

            normalizePendingSkills(member).forEach((skill) => {
              if (!skill?.name) return
              registerSkill(skill.name, {
                proficiencyLevel: skill.proficiencyLevel,
                experienceYears: skill.experienceYears,
                usageFrequency: skill.usageFrequency,
                requestedAt: skill.requestedAt,
                status: skill.status || 'pending',
                source: 'pending',
              })
            })

            if (Array.isArray(member.top_skills)) {
              const experienceGuess = typeof member.avg_years_experience === 'number'
                ? member.avg_years_experience
                : typeof member.average_years_experience === 'number'
                  ? member.average_years_experience
                  : null
              member.top_skills.forEach((skillName) => {
                if (!skillName) return
                registerSkill(skillName, {
                  proficiencyLevel: 'Expert',
                  experienceYears: experienceGuess ?? (member.skills_count ?? 5),
                  usageFrequency: 'Active use',
                  status: 'approved',
                  source: 'topSkill',
                })
              })
            }

            const matchedSkills = []
            let totalScore = 0
            prioritizedSkills.forEach((prioritySkill) => {
              const candidateSkill = profile.get(prioritySkill.key)
              if (!candidateSkill) return
              const contribution = prioritySkill.weight * candidateSkill.proficiencyScore
              totalScore += contribution
              matchedSkills.push({
                id: `${member.person_id}-${prioritySkill.skill_id}`,
                name: prioritySkill.label,
                type: `${prioritySkill.priority} priority`,
                requestedAt: candidateSkill.requestedAt,
                proficiencyLevel: candidateSkill.proficiencyLevel || 'Not specified',
                usageFrequency: candidateSkill.usageFrequency || 'Not specified',
                experienceYears: candidateSkill.experienceYears ?? null,
                notes: `Confidence ${(candidateSkill.proficiencyScore * 100).toFixed(0)}%`,
                status: candidateSkill.status || 'pending',
              })
            })

            if (!matchedSkills.length) {
              return null
            }

            const normalizedScore = Math.round((totalScore / maxScore) * 100)
            const coverageRatio = matchedSkills.length / prioritizedSkills.length
            const status = describeFitStatus(normalizedScore)

            return {
              id: member.person_id,
              name: member.name,
              role: member.role ?? 'Team Member',
              status,
              pendingCount: matchedSkills.length,
              pendingLabel: matchedSkills.length === 1 ? 'priority match' : 'priority matches',
              waitLabel: 'Fit',
              waitText: `${normalizedScore}% suitability`,
              matchScore: normalizedScore,
              coverageRatio,
              waitTimestamp: null,
              skills: matchedSkills,
            }
          })
          .filter(Boolean)
          .sort((a, b) => {
            if (b.matchScore !== a.matchScore) return b.matchScore - a.matchScore
            if (b.coverageRatio !== a.coverageRatio) return b.coverageRatio - a.coverageRatio
            return (a.name || '').localeCompare(b.name || '')
          })

        if (matches.length) {
          return matches.slice(0, 4)
        }
      }
    }

    if (Array.isArray(insights?.spotlight_matches) && insights.spotlight_matches.length) {
      return insights.spotlight_matches.map((match, index) => {
        const rawSkills = Array.isArray(match.skills)
          ? match.skills
          : Array.isArray(match.tags)
            ? match.tags.map((tag) => ({ name: tag }))
            : Array.isArray(match.top_skills)
              ? match.top_skills.map((tag) => ({ name: tag }))
              : []

        const matchValue = Number(match.match)
        const normalizedMatch = Number.isFinite(matchValue)
          ? (matchValue <= 1 ? Math.round(matchValue * 100) : Math.round(matchValue))
          : 60
        const status = describeFitStatus(normalizedMatch)

        return {
          id: match.person_id ?? match.id ?? `spotlight-${index}`,
          name: match.name ?? match.member_name ?? `Candidate ${index + 1}`,
          role: match.role ?? match.current_role ?? 'Team Member',
          status,
          pendingCount: rawSkills.length,
          pendingLabel: rawSkills.length === 1 ? 'priority match' : 'priority matches',
          waitLabel: 'Fit',
          waitText: `${normalizedMatch}% suitability`,
          skills: rawSkills.map((skill, skillIndex) => ({
            id: skill.id ?? skill.skill_id ?? `${index}-skill-${skillIndex}`,
            name: skill.name ?? skill.skill_name ?? `Skill ${skillIndex + 1}`,
            type: skill.type ?? skill.skill_type ?? 'Skill',
            requestedAt: skill.requested_at ?? skill.requestedAt ?? null,
            proficiencyLevel: skill.proficiencyLevel ?? skill.proficiency ?? null,
            usageFrequency: skill.usageFrequency ?? skill.frequency ?? null,
            experienceYears: skill.experienceYears ?? skill.years ?? null,
            status: skill.status ?? null,
            notes: skill.notes ?? null,
          })),
        }
      })
    }

    return teamMembers.slice(0, 3).map((member, index) => {
      const skills = Array.isArray(member.top_skills)
        ? member.top_skills.slice(0, 3).map((skillName, skillIndex) => ({
            id: `${member.person_id ?? index}-fallback-${skillIndex}`,
            name: skillName,
            type: 'Existing skill',
            requestedAt: null,
            proficiencyLevel: 'Experienced',
            usageFrequency: 'Core capability',
            experienceYears: null,
            status: 'approved',
            notes: 'Confidence 60%',
          }))
        : []

      const fallbackScore = Math.min(95, 55 + (member.skills_count ?? 3) * 5)
      const status = describeFitStatus(fallbackScore)

      return {
        id: member.person_id ?? `fallback-${index}`,
        name: member.name ?? `Candidate ${index + 1}`,
        role: member.role ?? 'Team Member',
        status,
        pendingCount: skills.length,
        pendingLabel: skills.length === 1 ? 'priority match' : 'priority matches',
        waitLabel: 'Fit',
        waitText: `${fallbackScore}% suitability`,
        skills,
      }
    })
  }, [highValueSkills, teamMembers, insights?.spotlight_matches, skillNameLookup])

  const teamReviewQueue = useMemo(() => {
    return teamMembers
      .map((member) => {
        const pendingSkills = normalizePendingSkills(member)
        const timestamps = pendingSkills
          .map((skill) => {
            if (!skill.requestedAt) return null
            const ms = new Date(skill.requestedAt).getTime()
            return Number.isNaN(ms) ? null : ms
          })
          .filter((value) => value !== null)
        const oldestPending = timestamps.length ? Math.min(...timestamps) : null

        return {
          id: member.person_id,
          name: member.name,
          role: member.role,
          status: 'pending',
          pendingCount: pendingSkills.length || member.pending_skills || 0,
          waitTimestamp: oldestPending,
          skills: pendingSkills,
        }
      })
      .filter((entry) => entry.pendingCount > 0)
      .sort((a, b) => {
        const aTime = a.waitTimestamp ?? Number.POSITIVE_INFINITY
        const bTime = b.waitTimestamp ?? Number.POSITIVE_INFINITY
        if (aTime !== bTime) return aTime - bTime
        return b.pendingCount - a.pendingCount
      })
  }, [teamMembers])

  const availableSkillOptions = useMemo(() => {
    return skillOptions.filter((skill) => !highValueSkills.some((entry) => entry.skill_id === skill.id))
  }, [skillOptions, highValueSkills])

  const handleHighValueFormChange = (e) => {
    const { name, value } = e.target
    setHighValueForm((prev) => ({ ...prev, [name]: value }))
  }

  const handleAddHighValueSkill = async (e) => {
    e.preventDefault()
    if (!highValueForm.skill_id) {
      setHighValueError('Select a skill to add')
      return
    }
    setHighValueLoading(true)
    setHighValueError(null)
    try {
      const payload = {
        skill_id: Number(highValueForm.skill_id),
        priority: highValueForm.priority,
        notes: highValueForm.notes?.trim() ?? '',
      }
      const response = await teamApi.addHighValueSkill(payload)
      setHighValueSkills((prev) => {
        const filtered = prev.filter((item) => item.skill_id !== response.data.skill_id)
        return [response.data, ...filtered]
      })
      setHighValueForm({ skill_id: '', priority: 'High', notes: '' })
    } catch (err) {
      setHighValueError('Unable to save skill: ' + err.message)
    } finally {
      setHighValueLoading(false)
    }
  }

  const handleDeleteHighValueSkill = async (id) => {
    if (!window.confirm('Remove this high-value skill?')) return
    try {
      await teamApi.deleteHighValueSkill(id)
      setHighValueSkills((prev) => prev.filter((skill) => skill.id !== id))
    } catch (err) {
      setHighValueError('Unable to remove skill: ' + err.message)
    }
  }

  const handleReviewAction = async (item, skill, nextStatus) => {
    const memberId = item?.id ?? item?.person_id
    const skillId = skill?.id ?? skill?.skill_id
    if (!memberId || !skillId) return

    const actionKey = `${memberId}-${skillId}`
    setReviewActionKey(actionKey)
    setReviewActionError(null)

    const action = nextStatus === 'Approved'
      ? () => teamApi.approveTeamMemberSkill(memberId, skillId)
      : () => teamApi.rejectTeamMemberSkill(memberId, skillId)

    try {
      await action()
      await fetchTeamData({ withLoader: false })
    } catch (err) {
      console.error('Failed to update skill status:', err)
      setReviewActionError(err.response?.data?.error || err.message || 'Unable to update the request.')
    } finally {
      setReviewActionKey(null)
    }
  }

  return (
    <div className="flex min-h-screen bg-[var(--background)] text-[var(--text-color)]">
      <Sidebar />

      <main className="flex-1 space-y-6 p-8">
        {error && (
          <div className="rounded-md bg-red-100 p-4 text-red-700">
            {error}
          </div>
        )}

        <header className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Manager UI</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">Team Management</h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">
            Keep your own skills current while reviewing the team roster. Employee tooling remains available so managers can
            update their personal inventory without switching contexts.
          </p>
        </header>

        {!loading && insights && (
          <section className="space-y-4">
            <div className="grid gap-4 lg:grid-cols-3">
              <div className="lg:col-span-2">
                <DataVolumeCounters items={overviewCounts} showTeams={false} />
              </div>
              <ApprovalQueuePriorityIndicator counts={approvalLatencyBuckets} />
            </div>

            <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Top Team Skills</h2>
              <ul className="mt-4 space-y-2">
                {(insights.top_skills || []).slice(0, 5).map((skill) => (
                  <li key={skill.skill_name ?? skill.name} className="flex items-center justify-between text-sm">
                    <span className="text-[var(--text-color)]">{skill.skill_name ?? skill.name}</span>
                    <span className="text-[var(--text-color-secondary)]">{skill.user_count ?? skill.count ?? 0} members</span>
                  </li>
                ))}
                {!insights.top_skills?.length && (
                  <li className="text-sm text-[var(--text-color-secondary)]">No skill insights available yet.</li>
                )}
              </ul>
            </div>
          </section>
        )}

        {!loading && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">High-Value Skills</p>
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Set Team Priorities</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">Highlight up to-date capabilities your team should focus on.</p>
            </div>
            <form onSubmit={handleAddHighValueSkill} className="grid gap-4 lg:grid-cols-4">
              <div className="lg:col-span-2">
                <label className="text-sm font-medium text-[var(--text-color)]">Skill</label>
                <select
                  name="skill_id"
                  value={highValueForm.skill_id}
                  onChange={handleHighValueFormChange}
                  className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]"
                >
                  <option value="">Select a skill...</option>
                  {availableSkillOptions.map((skill) => (
                    <option key={skill.id} value={skill.id}>{skill.name} • {skill.type}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="text-sm font-medium text-[var(--text-color)]">Priority</label>
                <select
                  name="priority"
                  value={highValueForm.priority}
                  onChange={handleHighValueFormChange}
                  className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]"
                >
                  <option value="High">High</option>
                  <option value="Medium">Medium</option>
                  <option value="Low">Low</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium text-[var(--text-color)]">Notes</label>
                <input
                  type="text"
                  name="notes"
                  value={highValueForm.notes}
                  onChange={handleHighValueFormChange}
                  placeholder="Why it matters"
                  className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]"
                />
              </div>
              <div className="flex items-end">
                <button
                  type="submit"
                  disabled={highValueLoading}
                  className="w-full rounded-md bg-[var(--color-primary)] px-4 py-2 text-white font-medium hover:bg-[var(--color-primary-dark)] disabled:opacity-60"
                >
                  {highValueLoading ? 'Saving...' : 'Add Skill'}
                </button>
              </div>
            </form>
            {highValueError && (
              <p className="text-sm text-red-600">{highValueError}</p>
            )}
            {highValueSkills.length === 0 ? (
              <p className="text-sm text-[var(--text-color-secondary)]">No high-value skills defined yet.</p>
            ) : (
              <div className="space-y-2">
                {highValueSkills.map((skill) => (
                  <div key={skill.id} className="flex flex-col gap-2 rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4 md:flex-row md:items-center md:justify-between">
                    <div>
                      <p className="font-semibold text-[var(--text-color)]">{skill.skill_name}</p>
                      <p className="text-xs text-[var(--text-color-secondary)]">{skill.skill_type} • Priority: {skill.priority}</p>
                      {skill.notes && <p className="text-xs text-[var(--text-color-secondary)]">Notes: {skill.notes}</p>}
                    </div>
                    <button
                      type="button"
                      onClick={() => handleDeleteHighValueSkill(skill.id)}
                      className="self-start rounded-md border border-red-200 px-3 py-1 text-sm font-medium text-red-600 hover:bg-red-50"
                    >
                      Remove
                    </button>
                  </div>
                ))}
              </div>
            )}
          </section>
        )}

        {!loading && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Team Review Queue</p>
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Pending Team Requests</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">Only includes members assigned to you as manager.</p>
              {reviewActionError && (
                <p className="mt-2 text-sm text-red-600">{reviewActionError}</p>
              )}
            </div>
            {teamReviewQueue.length === 0 ? (
              <p className="text-sm text-[var(--text-color-secondary)]">No pending skill requests from your team.</p>
            ) : (
              <div className="max-h-[34rem] overflow-y-auto pr-2">
                <SearchResultCards
                  results={teamReviewQueue}
                  onResolveSkill={handleReviewAction}
                  pendingActionKey={reviewActionKey}
                />
              </div>
            )}
          </section>
        )}

        <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-[var(--text-color)]">Team Members</h2>
          {loading ? (
            <p className="mt-4 text-[var(--text-color-secondary)]">Loading team members...</p>
          ) : teamMembers.length === 0 ? (
            <p className="mt-4 text-[var(--text-color-secondary)]">No team members found</p>
          ) : (
            <div className="mt-4 space-y-2">
              {teamMembers.map((member) => (
                <button
                  key={member.person_id}
                  onClick={() => handleSelectMember(member.person_id)}
                  className={`w-full text-left rounded-lg border p-4 transition ${
                    selectedMember === member.person_id
                      ? 'border-[var(--color-primary)] bg-[var(--background)]'
                      : 'border-[var(--border-color)] hover:bg-[var(--background)]'
                  }`}
                >
                  <p className="font-medium text-[var(--text-color)]">{member.name}</p>
                  <p className="text-sm text-[var(--text-color-secondary)]">Role: {member.role}</p>
                </button>
              ))}
            </div>
          )}
        </section>

        {selectedMember && memberDetails && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <h2 className="text-xl font-semibold text-[var(--text-color)]">Member Details: {memberDetails.name}</h2>
            <div className="mt-4">
              <h3 className="font-medium text-[var(--text-color)]">Skills</h3>
              {memberDetails.skills.length === 0 ? (
                <p className="mt-2 text-sm text-[var(--text-color-secondary)]">No skills recorded</p>
              ) : (
                <ul className="mt-2 space-y-2">
                  {memberDetails.skills.map((skill) => (
                    <li
                      key={skill.id}
                      className="rounded border border-[var(--border-color)] p-3 text-sm flex justify-between items-center"
                    >
                      <div>
                        <p className="font-medium text-[var(--text-color)]">{skill.name}</p>
                        <p className="text-xs text-[var(--text-color-secondary)]">{skill.type}</p>
                      </div>
                      <span className={`px-2 py-1 rounded text-xs font-semibold ${
                        skill.status === 'Approved'
                          ? 'bg-green-100 text-green-700'
                          : skill.status === 'Pending'
                          ? 'bg-yellow-100 text-yellow-700'
                          : 'bg-red-100 text-red-700'
                      }`}>
                        {skill.status}
                      </span>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          </section>
        )}

        {!loading && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Talent Spotlight</p>
              <h2 className="text-xl font-semibold text-[var(--text-color)]">High-value Matches</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">Use these insights to staff initiatives faster.</p>
            </div>
            {spotlightMatches.length === 0 ? (
              <p className="text-sm text-[var(--text-color-secondary)]">Add high-value skills to start surfacing matches.</p>
            ) : (
              <SearchResultCards results={spotlightMatches} />
            )}
          </section>
        )}
      </main>
    </div>
  )
}
