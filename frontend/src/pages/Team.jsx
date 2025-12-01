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
                      className="rounded border border-[var(--border-color)] p-3 text-sm flex justify-between items-center"
                    >
                      <div>
                        <p className="font-medium text-[var(--text-color)]">{skill.name}</p>
                        <p className="text-xs text-[var(--text-color-secondary)]">{skill.type}</p>
                      </div>
                      <span className={`px-2 py-1 rounded text-xs font-semibold ${
                        skill.status === 'Approved'
                          ? 'bg-green-100 text-green-700'
                          : skill.status === 'Requested'
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
      </main>
    </div>
  )
}
