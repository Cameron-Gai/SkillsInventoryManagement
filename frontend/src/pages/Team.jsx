// Team.jsx
// Manager dashboard for viewing and managing team members.

import { useState, useEffect } from 'react'
import Sidebar from '@/components/Sidebar'
import ApprovalQueuePriorityIndicator from '@/components/visuals/ApprovalQueuePriorityIndicator'
import usersApi from '@/api/usersApi'
import teamApi from '@/api/teamApi'
import skillsApi from '@/api/skillsApi'

export default function Team() {
  const [activeTab, setActiveTab] = useState('overview') // 'overview' | 'pending' | 'approved' | 'priorities' | 'matches'
  const [teamMembers, setTeamMembers] = useState([])
  const [insights, setInsights] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [selectedMember, setSelectedMember] = useState(null)
  const [memberDetails, setMemberDetails] = useState(null)
  const [pendingRequests, setPendingRequests] = useState([])
  const [confirmAction, setConfirmAction] = useState(null) // { memberId, skillId, action: 'approve'|'reject' }
  const [approvedSkills, setApprovedSkills] = useState([])
  
  // High-value skills state
  const [highValueSkills, setHighValueSkills] = useState([])
  const [skillOptions, setSkillOptions] = useState([])
  const [highValueForm, setHighValueForm] = useState({ skill_id: '', priority: 'High', notes: '' })
  const [highValueError, setHighValueError] = useState(null)
  const [highValueLoading, setHighValueLoading] = useState(false)

  // Helper functions for visual accents (consistent with Admin)
  const levelClasses = (level) => {
    if (!level) return 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
    const l = level.toLowerCase()
    if (l === 'beginner') return 'bg-[var(--level-beginner-bg)] text-[var(--level-beginner-fg)]'
    if (l === 'intermediate') return 'bg-[var(--level-intermediate-bg)] text-[var(--level-intermediate-fg)]'
    if (l === 'advanced') return 'bg-[var(--level-advanced-bg)] text-[var(--level-advanced-fg)]'
    if (l === 'expert') return 'bg-[var(--level-expert-bg)] text-[var(--level-expert-fg)]'
    return 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
  }

  const isHighValueEntry = (entry) => {
    const level = entry.level?.toLowerCase()
    const type = (entry.skill?.type || entry.type)?.toLowerCase()
    const freq = entry.frequency?.toLowerCase()
    return level === 'expert' && type === 'technology' && (freq === 'daily' || freq === 'weekly')
  }

  const timeAgo = (ts) => {
    if (!ts) return ''
    const dt = new Date(ts)
    const now = new Date()
    const diffMs = now - dt
    const sec = Math.floor(diffMs / 1000)
    const min = Math.floor(sec / 60)
    const hr = Math.floor(min / 60)
    const day = Math.floor(hr / 24)
    if (day > 0) return `${day} day${day === 1 ? '' : 's'} ago`
    if (hr > 0) return `${hr} hour${hr === 1 ? '' : 's'} ago`
    if (min > 0) return `${min} minute${min === 1 ? '' : 's'} ago`
    return `${sec} second${sec === 1 ? '' : 's'} ago`
  }

  useEffect(() => {
    const fetchTeamData = async () => {
      try {
        setLoading(true)
        setError(null)

        const [teamRes, insightsRes, approvedRes, highValueRes, skillsRes] = await Promise.all([
          teamApi.getMyTeam(),
          teamApi.getTeamInsights(),
          teamApi.getTeamApprovedSkills(),
          teamApi.getHighValueSkills(),
          skillsApi.getAllSkills(),
        ])

        setTeamMembers(teamRes.data || [])
        setInsights(insightsRes.data)
        setApprovedSkills(approvedRes.data || [])
        setHighValueSkills(highValueRes.data || [])
        setSkillOptions(skillsRes.data || [])

        // Fetch all team members' skills and collect pending requests
        const allPendingRequests = []
        for (const member of teamRes.data || []) {
          try {
            const memberRes = await teamApi.getTeamMember(member.person_id)
            const pendingSkills = memberRes.data.skills.filter(s => s.status === 'Requested')
            pendingSkills.forEach(skill => {
              allPendingRequests.push({
                ...skill,
                employeeName: memberRes.data.name,
                employeeId: member.person_id,
              })
            })
          } catch (err) {
            console.error('Error fetching member details:', err)
          }
        }
        setPendingRequests(allPendingRequests)
      } catch (err) {
        setError('Failed to load team data: ' + err.message)
        console.error('Error:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchTeamData()
  }, [])

  const handleSelectMember = async (memberId) => {
    try {
      const response = await teamApi.getTeamMember(memberId)
      setSelectedMember(memberId)
      setMemberDetails(response.data)
    } catch (err) {
      setError('Failed to load member details: ' + err.message)
    }
  }

  const handleApproveSkill = async (memberId, skillId) => {
    try {
      await teamApi.approveTeamMemberSkill(memberId, skillId)
      // Remove from pending requests
      setPendingRequests((prev) => prev.filter(req => !(req.employeeId === memberId && req.id === skillId)))
      // Update the member details if visible
      if (memberDetails) {
        setMemberDetails((prev) => ({
          ...prev,
          skills: prev.skills.map((skill) =>
            skill.id === skillId ? { ...skill, status: 'Approved' } : skill
          ),
        }))
      }
      // Optimistically update insights pending count
      setInsights(prev => prev ? { ...prev, pending_approvals: Math.max(0, (prev.pending_approvals || 0) - 1) } : prev)
    } catch (err) {
      setError('Failed to approve skill: ' + err.message)
    }
  }

  const handleRejectSkill = async (memberId, skillId) => {
    try {
      await teamApi.rejectTeamMemberSkill(memberId, skillId)
      // Remove from pending requests
      setPendingRequests((prev) => prev.filter(req => !(req.employeeId === memberId && req.id === skillId)))
      // Update the member details if visible
      if (memberDetails) {
        setMemberDetails((prev) => ({
          ...prev,
          skills: prev.skills.map((skill) =>
            skill.id === skillId ? { ...skill, status: 'Canceled' } : skill
          ),
        }))
      }
      // Optimistically update insights pending count
      setInsights(prev => prev ? { ...prev, pending_approvals: Math.max(0, (prev.pending_approvals || 0) - 1) } : prev)
    } catch (err) {
      setError('Failed to reject skill: ' + err.message)
    }
  }

  const handleAddHighValueSkill = async (e) => {
    e.preventDefault()
    if (!highValueForm.skill_id) {
      setHighValueError('Please select a skill')
      return
    }
    setHighValueLoading(true)
    setHighValueError(null)
    try {
      const response = await teamApi.addHighValueSkill({
        skill_id: Number(highValueForm.skill_id),
        priority: highValueForm.priority,
        notes: highValueForm.notes?.trim() || '',
      })
      setHighValueSkills((prev) => {
        const filtered = prev.filter((item) => item.skill_id !== response.data.skill_id)
        return [response.data, ...filtered]
      })
      setHighValueForm({ skill_id: '', priority: 'High', notes: '' })
    } catch (err) {
      setHighValueError('Failed to add high-value skill: ' + err.message)
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
      setHighValueError('Failed to remove high-value skill: ' + err.message)
    }
  }

  const availableSkillOptions = skillOptions.filter((skill) => 
    !highValueSkills.some((entry) => entry.skill_id === skill.id)
  )

  // Calculate data for visual components
  const overviewCounts = insights ? {
    skills: insights.total_approved || 0,
    employees: insights.team_size || 0,
    audits: insights.pending_approvals || 0,
  } : {}

  const approvalLatencyBuckets = (() => {
    const now = Date.now()
    const threeDays = 3 * 24 * 60 * 60 * 1000
    const sevenDays = 7 * 24 * 60 * 60 * 1000
    let underThree = 0, overThree = 0, overWeek = 0
    
    pendingRequests.forEach(req => {
      if (req.requested_at) {
        const age = now - new Date(req.requested_at).getTime()
        if (age <= threeDays) underThree++
        else if (age <= sevenDays) overThree++
        else overWeek++
      } else {
        underThree++ // No timestamp, assume new
      }
    })
    
    return { underThree, overThree, overWeek }
  })()

  // Feature flag: control visibility of High Value Matches render section
  const showMatches = false

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
            Manage your team’s skill inventory, review pending requests, and highlight priority capabilities for your team.
          </p>
        </header>

        {/* Approval Queue and Top Skills - Side by Side */}
        {!loading && (
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Top Team Skills */}
            {insights && insights.top_skills && insights.top_skills.length > 0 && (
              <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-lg font-semibold text-[var(--text-color)]">Top Team Skills</h2>
                  <span className="text-xs text-[var(--text-color-secondary)]">Last 5</span>
                </div>
                {(() => {
                  const top = insights.top_skills.slice(0, 5)
                  const maxCount = Math.max(...top.map(s => Number(s.user_count) || 0), 1)
                  return (
                    <ul className="space-y-2">
                      {top.map((skill) => {
                        const count = Number(skill.user_count) || 0
                        const pct = Math.round((count / maxCount) * 100)
                        return (
                          <li key={skill.skill_name} className="relative">
                            <div className="absolute inset-y-0 left-0 right-0 rounded-md bg-[var(--background-muted)]" aria-hidden="true" />
                            <div
                              className="absolute inset-y-0 left-0 rounded-md bg-red-500/30 dark:bg-red-300/20"
                              style={{ width: pct + '%' }}
                              aria-hidden="true"
                            />
                            <div className="relative flex items-center justify-between rounded-md px-3 py-2">
                              <span className="text-sm font-medium text-[var(--text-color)]">{skill.skill_name}</span>
                              <span className="inline-flex items-center gap-2">
                                <span className="text-xs text-[var(--text-color-secondary)]">
                                  {count} {count === 1 ? 'member' : 'members'}
                                </span>
                                <span className="text-[10px] px-2 py-0.5 rounded-full bg-[var(--background)] text-[var(--text-color-secondary)]">
                                  {pct}%
                                </span>
                              </span>
                            </div>
                          </li>
                        )
                      })}
                    </ul>
                  )
                })()}
              </section>
            )}

            {/* Approval Queue */}
            <ApprovalQueuePriorityIndicator counts={approvalLatencyBuckets} />
          </div>
        )}

        {/* Tab Navigation */}
        <div className="flex gap-2 border-b border-[var(--border-color)]">
          <button
            onClick={() => setActiveTab('overview')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'overview'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Overview
          </button>
          <button
            onClick={() => setActiveTab('pending')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'pending'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Pending Requests {pendingRequests.length > 0 && `(${pendingRequests.length})`}
          </button>
          <button
            onClick={() => setActiveTab('approved')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'approved'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Approved Skills
          </button>
          <button
            onClick={() => setActiveTab('priorities')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'priorities'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Team Priorities
          </button>
          {/* High Value Matches tab removed (functionality retained for future) */}
        </div>

        {/* Overview Tab: Team Members List */}
        {activeTab === 'overview' && (
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
                        ? 'border-[var(--color-primary)] bg-[var(--background-muted)]'
                        : 'border-[var(--border-color)] hover:bg-[var(--background-muted)]'
                    }`}
                  >
                    <p className="font-medium text-[var(--text-color)]">{member.name}</p>
                    <p className="text-sm text-[var(--text-color-secondary)]">Role: {member.role}</p>
                  </button>
                ))}
              </div>
            )}

            {selectedMember && memberDetails && (
              <div className="mt-6 rounded-lg border border-[var(--border-color)] p-4">
                <h3 className="text-lg font-semibold text-[var(--text-color)]">Member Details: {memberDetails.name}</h3>
                <div className="mt-4">
                  <h4 className="font-medium text-[var(--text-color)]">Skills</h4>
                  {memberDetails.skills.length === 0 ? (
                    <p className="mt-2 text-sm text-[var(--text-color-secondary)]">No skills recorded</p>
                  ) : (
                    <div className="mt-2 space-y-2">
                      {memberDetails.skills.map((skill) => (
                        <div
                          key={skill.id}
                          className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3 space-y-0"
                        >
                          <div className="flex flex-col gap-1 sm:flex-row sm:items-start sm:justify-between">
                            <div className="flex-1">
                              <p className="text-lg font-semibold text-[var(--text-color)]">
                                {skill.name}
                                {skill.type && (
                                  <span className="ml-2 text-sm font-normal text-[var(--text-color-secondary)]">• {skill.type}</span>
                                )}
                              </p>
                              {skill.status === 'Requested' && skill.requested_at && (
                                <p className="text-sm text-[var(--text-color-secondary)]">Requested {timeAgo(skill.requested_at)}</p>
                              )}
                            </div>
                            <div className="text-right flex flex-col items-end gap-1">
                              {skill.level && (
                                <span className={`px-2 py-0.5 rounded text-xs font-semibold ${levelClasses(skill.level)}`}>{skill.level}</span>
                              )}
                              {skill.years !== null && skill.years !== undefined && (
                                <p className="text-sm text-[var(--text-color-secondary)]">Experience: {skill.years} yrs</p>
                              )}
                              {skill.frequency && (
                                <p className="text-sm text-[var(--text-color-secondary)]">Frequency: {skill.frequency}</p>
                              )}
                            </div>
                          </div>

                          {skill.notes && (
                            <p className="text-base text-[var(--text-color-secondary)]">{skill.notes.trim()}</p>
                          )}

                          <div className="flex items-center justify-between">
                            <span className={`px-2 py-1 rounded text-xs font-semibold whitespace-nowrap ${
                              skill.status === 'Approved'
                                ? 'bg-green-100 text-green-700'
                                : skill.status === 'Requested'
                                ? 'bg-yellow-100 text-yellow-700'
                                : 'bg-red-100 text-red-700'
                            }`}>
                              {skill.status}
                            </span>
                            {skill.status === 'Requested' && (
                              <div className="flex flex-wrap gap-2 justify-end">
                                <button
                                  onClick={() => setConfirmAction({ memberId: selectedMember, skillId: skill.id, action: 'approve' })}
                                  className="rounded-md border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-sm font-semibold text-emerald-700 transition hover:bg-emerald-100"
                                >
                                  Approve
                                </button>
                                <button
                                  onClick={() => setConfirmAction({ memberId: selectedMember, skillId: skill.id, action: 'reject' })}
                                  className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
                                >
                                  Reject
                                </button>
                              </div>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            )}
          </section>
        )}

        {/* Pending Requests Tab */}
        {activeTab === 'pending' && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Pending Skill Requests</h2>
              <div />
            </div>
            {loading ? (
              <p className="mt-4 text-[var(--text-color-secondary)]">Loading...</p>
            ) : pendingRequests.length === 0 ? (
              <p className="mt-4 text-[var(--text-color-secondary)]">No pending requests</p>
            ) : (
              <div className="mt-3 space-y-2">
                {pendingRequests.map((r) => (
                  <div key={`${r.employeeId}-${r.id}`} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3 space-y-0">
                    <div className="flex flex-col gap-1 sm:flex-row sm:items-start sm:justify-between">
                      <div className="flex-1">
                        <p className="text-lg font-semibold text-[var(--text-color)]">
                          {r.name}
                          {r.type && (
                            <span className="ml-2 text-sm font-normal text-[var(--text-color-secondary)]">• {r.type}</span>
                          )}
                        </p>
                        <p className="text-sm text-[var(--text-color-secondary)]">
                          Requested by {r.employeeName}
                          {r.requested_at && (
                            <span> {timeAgo(r.requested_at)}</span>
                          )}
                        </p>
                      </div>
                      <div className="text-right flex flex-col items-end gap-1">
                        {r.level && (
                          <span className={`px-2 py-0.5 rounded text-xs font-semibold ${levelClasses(r.level)}`}>{r.level}</span>
                        )}
                        {r.years !== null && r.years !== undefined && (
                          <p className="text-sm text-[var(--text-color-secondary)]">Experience: {r.years} yrs</p>
                        )}
                        {r.frequency && (
                          <p className="text-sm text-[var(--text-color-secondary)]">Frequency: {r.frequency}</p>
                        )}
                      </div>
                    </div>

                    <p className="text-base text-[var(--text-color-secondary)]">{r.notes?.trim() || 'No notes provided.'}</p>

                    <div className="flex flex-wrap gap-2 justify-end">
                      <button
                        type="button"
                        onClick={() => handleApproveSkill(r.employeeId, r.id)}
                        className="rounded-md border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-sm font-semibold text-emerald-700 transition hover:bg-emerald-100"
                      >
                        Approve
                      </button>
                      <button
                        type="button"
                        onClick={() => handleRejectSkill(r.employeeId, r.id)}
                        className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
                      >
                        Reject
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </section>
        )}

        {/* Approved Skills Tab */}
        {activeTab === 'approved' && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Approved Skills (Team)</h2>
              <button
                onClick={async () => {
                  try {
                    const approvedRes = await teamApi.getTeamApprovedSkills()
                    setApprovedSkills(approvedRes.data || [])
                  } catch (err) {
                    setError('Failed to refresh approved skills: ' + err.message)
                  }
                }}
                className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm hover:border-[color:var(--color-primary)] transition"
              >
                Refresh
              </button>
            </div>
            {loading ? (
              <p className="mt-4 text-[var(--text-color-secondary)]">Loading...</p>
            ) : approvedSkills.length === 0 ? (
              <p className="mt-4 text-[var(--text-color-secondary)]">No approved skills</p>
            ) : (
              <div className="mt-4 space-y-3">
                {approvedSkills.map((r) => (
                  <div key={`${r.person_id}-${r.skill.id}`} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3 space-y-0">
                    <div className="flex flex-col gap-1 sm:flex-row sm:items-start sm:justify-between">
                      <div className="flex-1">
                        <p className="text-lg font-semibold text-[var(--text-color)]">
                          {r.skill.name}
                          {r.skill.type && (
                            <span className="ml-2 text-sm font-normal text-[var(--text-color-secondary)]">• {r.skill.type}</span>
                          )}
                        </p>
                        <p className="text-sm text-[var(--text-color-secondary)]">
                          {r.name} ({r.username})
                        </p>
                      </div>
                      <div className="text-right flex flex-col items-end gap-1">
                        {r.level && (
                          <span className={`px-2 py-0.5 rounded text-xs font-semibold ${levelClasses(r.level)}`}>{r.level}</span>
                        )}
                        {r.years !== null && r.years !== undefined && (
                          <p className="text-sm text-[var(--text-color-secondary)]">Experience: {r.years} yrs</p>
                        )}
                        {r.frequency && (
                          <p className="text-sm text-[var(--text-color-secondary)]">Frequency: {r.frequency}</p>
                        )}
                      </div>
                    </div>

                    <p className="text-base text-[var(--text-color-secondary)]">{r.notes?.trim() || 'No notes provided.'}</p>

                    <div className="flex flex-wrap gap-2 justify-end">
                      <button
                        onClick={() => setConfirmAction({ memberId: r.person_id, skillId: r.skill.id, action: 'deleteApproved' })}
                        className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </section>
        )}

        {/* Team Priorities Tab */}
        {activeTab === 'priorities' && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">High-Value Skills</p>
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Set Team Priorities</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">Define which skills your team should focus on developing.</p>
            </div>
            
            <form onSubmit={handleAddHighValueSkill} className="grid gap-4 md:grid-cols-4">
              <div className="md:col-span-2">
                <label className="text-sm font-medium text-[var(--text-color)]">Skill</label>
                <select
                  value={highValueForm.skill_id}
                  onChange={(e) => setHighValueForm(prev => ({ ...prev, skill_id: e.target.value }))}
                  className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]"
                  disabled={highValueLoading}
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
                  value={highValueForm.priority}
                  onChange={(e) => setHighValueForm(prev => ({ ...prev, priority: e.target.value }))}
                  className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]"
                  disabled={highValueLoading}
                >
                  <option value="High">High</option>
                  <option value="Medium">Medium</option>
                  <option value="Low">Low</option>
                </select>
              </div>
              <div className="flex items-end">
                <button
                  type="submit"
                  disabled={highValueLoading}
                  className="w-full rounded-md bg-[var(--color-primary)] px-4 py-2 text-white font-medium hover:bg-[var(--color-primary-dark)] disabled:opacity-60 transition"
                >
                  {highValueLoading ? 'Adding...' : 'Add Skill'}
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
                  <div key={skill.id} className="flex items-center justify-between rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4">
                    <div>
                      <p className="font-semibold text-[var(--text-color)]">{skill.skill_name}</p>
                      <p className="text-xs text-[var(--text-color-secondary)]">
                        {skill.skill_type} • Priority: {skill.priority}
                        {skill.notes && ` • ${skill.notes}`}
                      </p>
                    </div>
                    <button
                      onClick={() => handleDeleteHighValueSkill(skill.id)}
                      className="rounded-md border border-red-300 px-3 py-1.5 text-sm font-medium text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition"
                    >
                      Remove
                    </button>
                  </div>
                ))}
              </div>
            )}
          </section>
        )}

        {/* High Value Matches Tab */}
        {showMatches && activeTab === 'matches' && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">High-Value Matches</p>
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Team Members with Priority Skills</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">Team members who have the high-value skills you've prioritized.</p>
            </div>

            {(() => {
              const highValueSkillIds = new Set(highValueSkills.map(hvs => hvs.skill_id))
              const matches = approvedSkills.filter(skill => highValueSkillIds.has(skill.skill.id))
              
              if (highValueSkills.length === 0) {
                return (
                  <p className="text-sm text-[var(--text-color-secondary)]">
                    No high-value skills defined yet. Go to Team Priorities to set them.
                  </p>
                )
              }

              if (matches.length === 0) {
                return (
                  <p className="text-sm text-[var(--text-color-secondary)]">
                    No team members have the prioritized skills yet. Encourage skill development!
                  </p>
                )
              }

              // Group by person to show each team member with their priority skills
              const byPerson = matches.reduce((acc, match) => {
                const personId = match.person_id
                if (!acc[personId]) {
                  acc[personId] = {
                    person: { id: personId, name: match.name, username: match.username },
                    skills: []
                  }
                }
                acc[personId].skills.push(match)
                return acc
              }, {})

              return (
                <div className="space-y-3">
                  {Object.values(byPerson).map(({ person, skills }) => {
                    const totalFit = skills.reduce((sum, s) => sum + computeFitScoreEntry(s), 0)
                    const avgFit = Math.round(totalFit / skills.length)
                    
                    return (
                      <div key={person.id} className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm space-y-4">
                        <div className="flex items-start justify-between gap-4">
                          <div>
                            <h4 className="text-lg font-semibold text-[var(--text-color)]">{person.name}</h4>
                            <p className="text-sm text-[var(--text-color-secondary)]">{person.role || 'manager'}</p>
                            <p className="text-xs text-[var(--text-color-secondary)]">
                              {skills.length} priority {skills.length === 1 ? 'match' : 'matches'}
                            </p>
                          </div>
                          <div className="text-right space-y-1">
                            <span className="inline-flex items-center rounded-full bg-green-100 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wide text-green-700 dark:bg-green-900 dark:text-green-300">
                              ● Great
                            </span>
                            <p className="text-xs text-[var(--text-color-secondary)]">
                              Fit {avgFit}% match
                            </p>
                          </div>
                        </div>
                        
                        <div className="space-y-2">
                          {skills
                            .sort((a, b) => computeFitScoreEntry(b) - computeFitScoreEntry(a))
                            .map((skill) => {
                              const matchedPriority = highValueSkills.find(hvs => hvs.skill_id === skill.skill.id)
                              return (
                                <div key={`${person.id}-${skill.skill.id}`} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3">
                                  <div className="flex items-start justify-between gap-4">
                                    <div className="flex-1">
                                      <p className="text-sm font-medium text-[var(--text-color)]">{skill.skill.name}</p>
                                      <p className="text-xs text-[var(--text-color-secondary)] mt-0.5">
                                        {matchedPriority?.priority || 'High'} priority
                                      </p>
                                      <div className="mt-2 flex items-center gap-4 text-xs text-[var(--text-color-secondary)]">
                                        <span>Proficiency: {skill.level || 'Intermediate'}</span>
                                        <span>Usage: {skill.frequency || 'Not specified'}</span>
                                        <span>Experience: {typeof skill.years === 'number' ? `${skill.years} yr${skill.years === 1 ? '' : 's'}` : 'Not specified'}</span>
                                      </div>
                                      {matchedPriority?.notes && (
                                        <p className="mt-2 text-xs italic text-[var(--text-color-secondary)]">
                                          Notes: {matchedPriority.notes}
                                        </p>
                                      )}
                                      {skill.notes && !matchedPriority?.notes && (
                                        <p className="mt-2 text-xs italic text-[var(--text-color-secondary)]">
                                          Notes: {skill.notes}
                                        </p>
                                      )}
                                    </div>
                                  </div>
                                </div>
                              )
                            })}
                        </div>
                      </div>
                    )
                  })}
                </div>
              )
            })()}
          </section>
        )}

        {/* Approval/Cancellation Confirmation Modal */}
        {confirmAction && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
            <div className="w-full max-w-md rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
              <h3 className="text-xl font-semibold text-[var(--text-color)]">
                {confirmAction.action === 'approve' ? 'Confirm Approval'
                  : confirmAction.action === 'reject' ? 'Confirm Cancellation'
                  : 'Delete Approved Skill'}
              </h3>
              <p className="mt-3 text-sm text-[var(--text-color-secondary)]">
                {confirmAction.action === 'deleteApproved' ? 'Are you sure you want to delete this approved skill?' : `Are you sure you want to ${confirmAction.action} this request?`}
              </p>
              <div className="mt-6 flex justify-end gap-3">
                <button onClick={() => setConfirmAction(null)} className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]">Cancel</button>
                <button
                  onClick={async () => {
                    if (confirmAction.action === 'approve') {
                      await handleApproveSkill(confirmAction.memberId, confirmAction.skillId)
                    } else if (confirmAction.action === 'reject') {
                      await handleRejectSkill(confirmAction.memberId, confirmAction.skillId)
                    } else if (confirmAction.action === 'deleteApproved') {
                      await teamApi.deleteMemberSkill(confirmAction.memberId, confirmAction.skillId)
                      setApprovedSkills(prev => prev.filter(s => !(s.person_id === confirmAction.memberId && s.skill.id === confirmAction.skillId)))
                    }
                    setConfirmAction(null)
                  }}
                  className={`rounded-md px-4 py-2 text-sm font-semibold text-white transition ${confirmAction.action === 'approve' ? 'bg-green-600 hover:bg-green-700' : confirmAction.action === 'reject' ? 'bg-red-600 hover:bg-red-700' : 'bg-red-600 hover:bg-red-700'}`}
                >
                  {confirmAction.action === 'approve' ? 'Approve' : confirmAction.action === 'reject' ? 'Cancel Request' : 'Delete'}
                </button>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  )
}
