// Admin.jsx
// Admin dashboard with user and skill management.

import { useState, useEffect } from 'react'
import Sidebar from '@/components/Sidebar'
import usersApi from '@/api/usersApi'
import skillsApi from '@/api/skillsApi'
import teamApi from '@/api/teamApi'

export default function Admin() {
  const [users, setUsers] = useState([])
  const [skills, setSkills] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [activeTab, setActiveTab] = useState('users') // 'users' | 'skills' | 'userSkills' | 'requests' | 'logs'
  const [newSkillForm, setNewSkillForm] = useState({ skill_name: '', skill_type: 'Technology' })
  const [requests, setRequests] = useState([])
  const [requestsPage, setRequestsPage] = useState(1)
  const [requestsTotal, setRequestsTotal] = useState(0)
  const [requestsFilter, setRequestsFilter] = useState('Requested') // pending-only
  const [confirmDeleteUserId, setConfirmDeleteUserId] = useState(null)
  const [confirmRequest, setConfirmRequest] = useState(null) // { person_id, skill_id, action: 'approve'|'reject' }
  const [logs, setLogs] = useState([])

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true)
        setError(null)

        const [usersRes, skillsRes] = await Promise.all([
          usersApi.getAllUsers(),
          skillsApi.getAllSkills(),
        ])
        // Initial admin requests load: pending only
        const reqRes = await teamApi.getAdminRequests({ page: 1, pageSize: 20, status: 'Requested' })
        setRequests(reqRes.data.items || [])
        setRequestsTotal(reqRes.data.total || 0)
        setRequestsFilter('Requested')

        // Initial logs: approved + canceled
        try {
          const approvedRes = await teamApi.getAdminRequests({ page: 1, pageSize: 50, status: 'Approved' })
          const canceledRes = await teamApi.getAdminRequests({ page: 1, pageSize: 50, status: 'Canceled' })
          const approvedItems = (approvedRes.data.items || []).map(i => ({ ...i, status: 'Approved' }))
          const canceledItems = (canceledRes.data.items || []).map(i => ({ ...i, status: 'Canceled' }))
          setLogs([...approvedItems, ...canceledItems])
        } catch (e) {
          console.warn('Failed to pre-load logs', e)
        }

        setUsers(usersRes.data || [])
        setSkills(skillsRes.data || [])
      } catch (err) {
        setError('Failed to load data: ' + err.message)
        console.error('Error:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchData()
  }, [])

  const reloadRequests = async (page = requestsPage, status = 'Requested') => {
    try {
      const reqRes = await teamApi.getAdminRequests({ page, pageSize: 20, status })
      setRequests(reqRes.data.items || [])
      setRequestsTotal(reqRes.data.total || 0)
      setRequestsPage(page)
    } catch (err) {
      setError('Failed to load requests: ' + err.message)
    }
  }

  const reloadLogs = async () => {
    try {
      const approvedRes = await teamApi.getAdminRequests({ page: 1, pageSize: 50, status: 'Approved' })
      const canceledRes = await teamApi.getAdminRequests({ page: 1, pageSize: 50, status: 'Canceled' })
      const approvedItems = (approvedRes.data.items || []).map(i => ({ ...i, status: 'Approved' }))
      const canceledItems = (canceledRes.data.items || []).map(i => ({ ...i, status: 'Canceled' }))
      setLogs([...approvedItems, ...canceledItems])
    } catch (err) {
      setError('Failed to load logs: ' + err.message)
    }
  }

  const handleDeleteUser = (userId) => {
    setConfirmDeleteUserId(userId)
  }

  const confirmDeleteUser = async () => {
    try {
      await usersApi.deleteUser(confirmDeleteUserId)
      setUsers((prev) => prev.filter((u) => u.person_id !== confirmDeleteUserId))
      setConfirmDeleteUserId(null)
      setError(null)
    } catch (err) {
      setError('Failed to delete user: ' + err.message)
      setConfirmDeleteUserId(null)
    }
  }

  const cancelDeleteUser = () => setConfirmDeleteUserId(null)

  const handleAddSkill = async (e) => {
    e.preventDefault()
    if (!newSkillForm.skill_name.trim()) return

    try {
      const response = await skillsApi.createSkill({
        name: newSkillForm.skill_name,
        type: newSkillForm.skill_type,
      })
      setSkills((prev) => [...prev, response.data])
      setNewSkillForm({ skill_name: '', skill_type: 'Technology' })
      setError(null)
    } catch (err) {
      setError('Failed to add skill: ' + err.message)
    }
  }

  const handleDeleteSkill = async (skillId) => {
    if (!window.confirm('Are you sure you want to delete this skill?')) return

    try {
      await skillsApi.deleteSkill(skillId)
      setSkills((prev) => prev.filter((s) => s.id !== skillId))
      setError(null)
    } catch (err) {
      setError('Failed to delete skill: ' + err.message)
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
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Admin UI</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">Platform Administration</h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">
            Manage users, skills, and platform settings. You retain the full employee dashboard for your own profile while gaining
            access to these administrative tools.
          </p>
        </header>

        <div className="flex gap-4 border-b border-[var(--border-color)]">
          <button
            onClick={() => setActiveTab('users')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'users'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Users ({users.length})
          </button>
          <button
            onClick={() => setActiveTab('skills')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'skills'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Skills ({skills.length})
          </button>
          <button
            onClick={async () => { setActiveTab('userSkills'); await reloadRequests(1, 'Approved') }}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'userSkills'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            User Skills
          </button>
          <button
            onClick={async () => { setActiveTab('requests'); await reloadRequests(1, 'Requested') }}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'requests'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Requests ({requestsTotal})
          </button>
          <button
            onClick={async () => { setActiveTab('logs'); await reloadLogs() }}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'logs'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Logs
          </button>
        </div>

        {loading ? (
          <p className="text-[var(--text-color-secondary)]">Loading...</p>
        ) : activeTab === 'users' ? (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <h2 className="text-xl font-semibold text-[var(--text-color)]">Users</h2>
            <div className="mt-4 space-y-2 max-h-96 overflow-y-auto">
              {users.map((user) => (
                <div
                  key={user.person_id}
                  className="flex items-center justify-between rounded-lg border border-[var(--border-color)] p-4"
                >
                  <div>
                    <p className="font-medium text-[var(--text-color)]">{user.name}</p>
                    <p className="text-sm text-[var(--text-color-secondary)]">ID: {user.person_id} • Role: {user.role}</p>
                  </div>
                    <button
                      onClick={() => handleDeleteUser(user.person_id)}
                      className="px-3 py-1 text-sm font-medium text-red-600 border border-red-200 rounded hover:bg-red-50"
                    >
                      Delete
                    </button>
                </div>
              ))}
            </div>
          </section>
        ) : activeTab === 'skills' ? (
          <div className="space-y-6">
            <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Add New Skill</h2>
              <form onSubmit={handleAddSkill} className="mt-4 space-y-4 max-w-md">
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">Skill Name</label>
                  <input
                    type="text"
                    value={newSkillForm.skill_name}
                    onChange={(e) => setNewSkillForm((prev) => ({ ...prev, skill_name: e.target.value }))}
                    required
                    className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                    placeholder="e.g., React, Project Management"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">Skill Type</label>
                  <select
                    value={newSkillForm.skill_type}
                    onChange={(e) => setNewSkillForm((prev) => ({ ...prev, skill_type: e.target.value }))}
                    className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                  >
                    <option>Technology</option>
                    <option>Knowledge</option>
                    <option>Experience</option>
                    <option>Other</option>
                  </select>
                </div>
                <button
                  type="submit"
                  className="w-full rounded-md bg-[var(--color-primary)] px-4 py-2 text-white font-medium hover:bg-[var(--color-primary-dark)]"
                >
                  Add Skill
                </button>
              </form>
            </section>

            <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Skills Library</h2>
              <div className="mt-4 space-y-2 max-h-96 overflow-y-auto">
                {skills.map((skill) => (
                  <div
                    key={skill.id}
                    className="flex items-center justify-between rounded-lg border border-[var(--border-color)] p-4"
                  >
                    <div>
                      <p className="font-medium text-[var(--text-color)]">{skill.name}</p>
                      <p className="text-sm text-[var(--text-color-secondary)]">Type: {skill.type}</p>
                    </div>
                    <button
                      onClick={() => handleDeleteSkill(skill.id)}
                      className="px-3 py-1 text-sm font-medium text-red-600 border border-red-200 rounded hover:bg-red-50"
                    >
                      Delete
                    </button>
                  </div>
                ))}
              </div>
            </section>
          </div>
        ) : activeTab === 'userSkills' ? (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <h2 className="text-xl font-semibold text-[var(--text-color)]">All Approved User Skills</h2>
            <p className="text-sm text-[var(--text-color-secondary)]">A consolidated list of all approved skills across users. You can delete entries.</p>
            <div className="mt-4 flex items-center justify-between">
              <div />
              <button onClick={async () => await reloadRequests(1, 'Approved')} className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm">Refresh</button>
            </div>
            <div className="mt-4 space-y-3">
              {requests.length === 0 ? (
                <p className="text-sm text-[var(--text-color-secondary)]">No approved skills found.</p>
              ) : (
                requests.map((r) => (
                  <div key={`${r.person_id}-${r.skill.id}`} className="rounded-lg border border-[var(--border-color)] p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1">
                        <p className="font-semibold text-[var(--text-color)]">{r.skill.name}</p>
                        <p className="text-xs text-[var(--text-color-secondary)]">{r.name} • {r.username}</p>
                        <div className="mt-2 grid grid-cols-2 md:grid-cols-4 gap-2 text-xs text-[var(--text-color-secondary)]">
                          {r.level && <div><span className="font-medium">Level:</span> {r.level}</div>}
                          {r.years !== null && r.years !== undefined && <div><span className="font-medium">Experience:</span> {r.years} yrs</div>}
                          {r.frequency && <div><span className="font-medium">Frequency:</span> {r.frequency}</div>}
                          {r.notes && <div className="col-span-2"><span className="font-medium">Notes:</span> {r.notes}</div>}
                        </div>
                      </div>
                      <div className="flex gap-2">
                        <button onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'delete' })} className="px-3 py-1.5 text-sm rounded border border-red-300 text-red-600">Delete</button>
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </section>
        ) : activeTab === 'requests' ? (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Pending Skill Requests</h2>
              <div />
            </div>

            <div className="mt-4 space-y-3">
              {requests.map((r) => (
                <div key={`${r.person_id}-${r.skill.id}`} className="rounded-lg border border-[var(--border-color)] p-4 flex items-start gap-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <p className="font-semibold text-[var(--text-color)]">{r.skill.name}</p>
                      <span className="text-xs px-2 py-0.5 rounded bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300">{r.skill.type}</span>
                    </div>
                    <p className="text-sm text-[var(--text-color-secondary)]">{r.name} • {r.username}</p>
                    <div className="mt-2 grid grid-cols-2 md:grid-cols-4 gap-2 text-xs text-[var(--text-color-secondary)]">
                      {r.level && <div><span className="font-medium">Level:</span> {r.level}</div>}
                      {r.years !== null && r.years !== undefined && <div><span className="font-medium">Experience:</span> {r.years} yrs</div>}
                      {r.frequency && <div><span className="font-medium">Frequency:</span> {r.frequency}</div>}
                    </div>
                    {r.notes && <p className="mt-2 text-xs italic text-[var(--text-color-secondary)]">"{r.notes}"</p>}
                  </div>
                  <div className="flex items-start gap-2">
                    <span className={`px-2 py-1 rounded text-xs font-semibold whitespace-nowrap ${
                      r.status === 'Approved' ? 'bg-green-100 text-green-700' : r.status === 'Requested' ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-700'
                    }`}>{r.status}</span>
                    {r.status === 'Requested' && (
                      <>
                        <button
                          onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'approve' })}
                          className="flex items-center justify-center w-9 h-9 rounded-full bg-green-600 hover:bg-green-700 text-white transition"
                          title="Approve"
                        >
                          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" /></svg>
                        </button>
                        <button
                          onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'reject' })}
                          className="flex items-center justify-center w-9 h-9 rounded-full bg-red-600 hover:bg-red-700 text-white transition"
                          title="Reject"
                        >
                          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M6 18L18 6M6 6l12 12" /></svg>
                        </button>
                      </>
                    )}
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-4 flex items-center justify-between">
              <button
                onClick={async () => { const p = Math.max(1, requestsPage - 1); await reloadRequests(p, 'Requested') }}
                className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm"
                disabled={requestsPage <= 1}
              >
                Previous
              </button>
              <p className="text-sm text-[var(--text-color-secondary)]">Page {requestsPage}</p>
              <button
                onClick={async () => { const p = requests.length < 20 ? requestsPage : requestsPage + 1; await reloadRequests(p, 'Requested') }}
                className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm"
                disabled={requests.length < 20}
              >
                Next
              </button>
            </div>
          </section>
        ) : (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Logs (Approved & Canceled)</h2>
              <button onClick={reloadLogs} className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm">Refresh</button>
            </div>
            <div className="mt-4 space-y-3">
              {logs.length === 0 ? (
                <p className="text-sm text-[var(--text-color-secondary)]">No logs yet.</p>
              ) : (
                logs.map((r) => (
                  <div key={`log-${r.status}-${r.person_id}-${r.skill.id}`} className="rounded-lg border border-[var(--border-color)] p-4 flex items-start gap-4">
                    <div className="flex-1">
                      <div className="flex items-center gap-2">
                        <p className="font-semibold text-[var(--text-color)]">{r.skill.name}</p>
                        <span className="text-xs px-2 py-0.5 rounded bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-300">{r.skill.type}</span>
                      </div>
                      <p className="text-sm text-[var(--text-color-secondary)]">{r.name} • {r.username}</p>
                      <div className="mt-2 grid grid-cols-2 md:grid-cols-4 gap-2 text-xs text-[var(--text-color-secondary)]">
                        {r.level && <div><span className="font-medium">Level:</span> {r.level}</div>}
                        {r.years !== null && r.years !== undefined && <div><span className="font-medium">Experience:</span> {r.years} yrs</div>}
                        {r.frequency && <div><span className="font-medium">Frequency:</span> {r.frequency}</div>}
                      </div>
                      {r.notes && <p className="mt-2 text-xs italic text-[var(--text-color-secondary)]">"{r.notes}"</p>}
                    </div>
                    <span className={`px-2 py-1 rounded text-xs font-semibold whitespace-nowrap ${r.status === 'Approved' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>{r.status}</span>
                  </div>
                ))
              )}
            </div>
          </section>
        )}

      {/* Delete User Confirmation Modal */}
      {confirmDeleteUserId && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
            <h3 className="text-xl font-semibold text-[var(--text-color)]">Delete User</h3>
            <p className="mt-3 text-sm text-[var(--text-color-secondary)]">Are you sure you want to delete this user? This action cannot be undone.</p>
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={cancelDeleteUser} className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]">Cancel</button>
              <button onClick={confirmDeleteUser} className="rounded-md bg-red-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-700">Delete</button>
            </div>
          </div>
        </div>
      )}

      {/* Approve/Reject/Delete Confirmation Modal */}
      {confirmRequest && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
            <h3 className="text-xl font-semibold text-[var(--text-color)]">
              {confirmRequest.action === 'approve' ? 'Confirm Approval'
                : confirmRequest.action === 'reject' ? 'Confirm Cancellation'
                : 'Delete User Skill'}
            </h3>
            <p className="mt-3 text-sm text-[var(--text-color-secondary)]">
              {confirmRequest.action === 'delete' ? 'Are you sure you want to delete this approved skill?' : `Are you sure you want to ${confirmRequest.action} this request?`}
            </p>
            <div className="mt-6 flex justify-end gap-3">
              <button onClick={() => setConfirmRequest(null)} className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]">Cancel</button>
              <button
                onClick={async () => {
                  try {
                    if (confirmRequest.action === 'approve') {
                      await teamApi.approveTeamMemberSkill(confirmRequest.person_id, confirmRequest.skill_id)
                    } else if (confirmRequest.action === 'reject') {
                      await teamApi.rejectTeamMemberSkill(confirmRequest.person_id, confirmRequest.skill_id)
                    } else if (confirmRequest.action === 'delete') {
                      await teamApi.deleteMemberSkill(confirmRequest.person_id, confirmRequest.skill_id)
                    }
                    setConfirmRequest(null)
                    await reloadRequests(1, 'Requested')
                  } catch (err) {
                    setError('Action failed: ' + err.message)
                    setConfirmRequest(null)
                  }
                }}
                className={`rounded-md px-4 py-2 text-sm font-semibold text-white transition ${confirmRequest.action === 'approve' ? 'bg-green-600 hover:bg-green-700' : confirmRequest.action === 'reject' ? 'bg-red-600 hover:bg-red-700' : 'bg-red-600 hover:bg-red-700'}`}
              >
                {confirmRequest.action === 'approve' ? 'Approve' : confirmRequest.action === 'reject' ? 'Cancel Request' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}
      </main>
    </div>
  )
}
