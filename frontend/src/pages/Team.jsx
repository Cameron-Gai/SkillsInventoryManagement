// Team.jsx
// Manager dashboard for viewing and managing team members.

import { useState, useEffect } from 'react'
import Sidebar from '@/components/Sidebar'
import usersApi from '@/api/usersApi'
import teamApi from '@/api/teamApi'

export default function Team() {
  const [teamMembers, setTeamMembers] = useState([])
  const [insights, setInsights] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [selectedMember, setSelectedMember] = useState(null)
  const [memberDetails, setMemberDetails] = useState(null)
  const [pendingRequests, setPendingRequests] = useState([])

  useEffect(() => {
    const fetchTeamData = async () => {
      try {
        setLoading(true)
        setError(null)

        const [teamRes, insightsRes] = await Promise.all([
          teamApi.getMyTeam(),
          teamApi.getTeamInsights(),
        ])

        setTeamMembers(teamRes.data || [])
        setInsights(insightsRes.data)

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

        {/* Pending Requests Section */}
        {!loading && pendingRequests.length > 0 && (
          <section className="rounded-xl border border-yellow-300 bg-yellow-50 dark:bg-yellow-900/20 p-6 shadow-sm">
            <h2 className="text-xl font-semibold text-[var(--text-color)] flex items-center gap-2">
              <span className="text-2xl">⏳</span>
              Pending Skill Requests ({pendingRequests.length})
            </h2>
            <div className="mt-4 space-y-3">
              {pendingRequests.map((request) => (
                <div
                  key={`${request.employeeId}-${request.id}`}
                  className="rounded-lg border border-[var(--border-color)] bg-[var(--card-background)] p-4 flex items-start gap-4"
                >
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-1">
                      <p className="font-semibold text-[var(--text-color)]">{request.name}</p>
                      <span className="text-xs px-2 py-0.5 rounded bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300">
                        {request.type}
                      </span>
                    </div>
                    <p className="text-sm text-[var(--text-color-secondary)] mb-2">
                      Requested by: <span className="font-medium">{request.employeeName}</span>
                    </p>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-xs text-[var(--text-color-secondary)]">
                      {request.level && (
                        <div className="flex items-center gap-1">
                          <span className="font-medium">Level:</span> {request.level}
                        </div>
                      )}
                      {request.years !== null && request.years !== undefined && (
                        <div className="flex items-center gap-1">
                          <span className="font-medium">Experience:</span> {request.years} yrs
                        </div>
                      )}
                      {request.frequency && (
                        <div className="flex items-center gap-1">
                          <span className="font-medium">Frequency:</span> {request.frequency}
                        </div>
                      )}
                    </div>
                    {request.notes && (
                      <p className="mt-2 text-xs text-[var(--text-color-secondary)] italic">
                        "{request.notes}"
                      </p>
                    )}
                  </div>
                  <div className="flex gap-2 items-start">
                    <button
                      onClick={() => handleApproveSkill(request.employeeId, request.id)}
                      className="flex items-center justify-center w-10 h-10 rounded-full bg-green-600 hover:bg-green-700 text-white transition-colors shadow-md"
                      title="Approve"
                    >
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                      </svg>
                    </button>
                    <button
                      onClick={() => handleRejectSkill(request.employeeId, request.id)}
                      className="flex items-center justify-center w-10 h-10 rounded-full bg-red-600 hover:bg-red-700 text-white transition-colors shadow-md"
                      title="Reject"
                    >
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </section>
        )}

        {!loading && insights && (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <h2 className="text-xl font-semibold text-[var(--text-color)]">Team Snapshot</h2>
            <div className="mt-4 grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="rounded-lg border border-[var(--border-color)] p-4">
                <p className="text-sm text-[var(--text-color-secondary)]">Team Size</p>
                <p className="text-2xl font-bold text-[var(--text-color)]">{insights.team_size}</p>
              </div>
              <div className="rounded-lg border border-[var(--border-color)] p-4">
                <p className="text-sm text-[var(--text-color-secondary)]">Pending Approvals</p>
                <p className="text-2xl font-bold text-[var(--text-color)]">{insights.pending_approvals}</p>
              </div>
              <div className="rounded-lg border border-[var(--border-color)] p-4">
                <p className="text-sm text-[var(--text-color-secondary)]">Top Skills</p>
                <ul className="mt-2 space-y-1">
                  {insights.top_skills.slice(0, 3).map((skill) => (
                    <li key={skill.skill_name} className="text-sm text-[var(--text-color)]">
                      {skill.skill_name} ({skill.user_count})
                    </li>
                  ))}
                </ul>
              </div>
            </div>
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
                      className="rounded border border-[var(--border-color)] p-3 text-sm"
                    >
                      <div className="flex justify-between items-start">
                        <div className="flex-1">
                          <p className="font-medium text-[var(--text-color)]">{skill.name}</p>
                          <p className="text-xs text-[var(--text-color-secondary)]">{skill.type}</p>
                          
                          {/* Show details for all skills */}
                          <div className="mt-2 space-y-1 text-xs text-[var(--text-color-secondary)]">
                            {skill.level && <p><span className="font-medium">Level:</span> {skill.level}</p>}
                            {skill.years !== null && skill.years !== undefined && (
                              <p><span className="font-medium">Experience:</span> {skill.years} years</p>
                            )}
                            {skill.frequency && <p><span className="font-medium">Frequency:</span> {skill.frequency}</p>}
                            {skill.notes && (
                              <p className="mt-1"><span className="font-medium">Notes:</span> {skill.notes}</p>
                            )}
                          </div>
                        </div>
                        
                        <div className="flex items-center gap-2 ml-4">
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
                            <div className="flex gap-1">
                              <button
                                onClick={() => handleApproveSkill(selectedMember, skill.id)}
                                className="flex items-center justify-center w-8 h-8 rounded-full bg-green-600 hover:bg-green-700 text-white transition"
                                title="Approve"
                              >
                                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                                </svg>
                              </button>
                              <button
                                onClick={() => handleRejectSkill(selectedMember, skill.id)}
                                className="flex items-center justify-center w-8 h-8 rounded-full bg-red-600 hover:bg-red-700 text-white transition"
                                title="Reject"
                              >
                                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M6 18L18 6M6 6l12 12" />
                                </svg>
                              </button>
                            </div>
                          )}
                        </div>
                      </div>
                    </li>
                  ))}
                </ul>
              )}
            </div>
          </section>
        )}
      </main>
    </div>
  )
}
