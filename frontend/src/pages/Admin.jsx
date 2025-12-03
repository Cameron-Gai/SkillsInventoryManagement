// Admin.jsx
// Admin dashboard with user and skill management.

import { useState, useEffect, useRef } from 'react'
import Sidebar from '@/components/Sidebar'
import StatusBadges from '@/components/visuals/StatusBadges'
import usersApi from '@/api/usersApi'
import skillsApi from '@/api/skillsApi'
import teamApi from '@/api/teamApi'
import { getCatalogRequests, processCatalogRequest, updateCatalogRequest } from '@/api/catalogRequestsApi'
import { useToast } from '@/components/ToastProvider'

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

function isHighValueEntry(entry) {
  const tech = (entry?.skill?.type || '').toLowerCase() === 'technology'
  const highLevel = (entry?.level || '').toLowerCase() === 'expert'
  const freq = (entry?.frequency || '').toLowerCase()
  const often = freq === 'daily' || freq === 'weekly'
  return tech && highLevel && often
}

function timeAgo(ts) {
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

export default function Admin() {
  const { showToast } = useToast()
  const [users, setUsers] = useState([])
  const [skills, setSkills] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [activeTab, setActiveTab] = useState('users') // 'users' | 'skills' | 'userSkills' | 'requests' | 'logs'
  // Users tab filters/sort
  const [userSearch, setUserSearch] = useState('')
  const [userRoleFilter, setUserRoleFilter] = useState('all') // 'all' | 'employee' | 'manager' | 'admin'
  const [userSortField, setUserSortField] = useState('name') // 'name' | 'id' | 'skills'
  const [userSortDir, setUserSortDir] = useState('asc') // 'asc' | 'desc'
  const [selectedSkills, setSelectedSkills] = useState([]) // array of skill ids
  const [skillsSearch, setSkillsSearch] = useState('')
  const [showSkillsDropdown, setShowSkillsDropdown] = useState(false)
  const skillsDropdownRef = useRef(null)
  const [newSkillForm, setNewSkillForm] = useState({ skill_name: '', skill_type: 'Technology' })
  const [requests, setRequests] = useState([])
  const [catalogRequests, setCatalogRequests] = useState([])
  const [requestsPage, setRequestsPage] = useState(1)
  const [requestsTotal, setRequestsTotal] = useState(0)
  const [pendingCount, setPendingCount] = useState(0) // Track pending requests count for tab display
  const [requestsFilter, setRequestsFilter] = useState('Requested') // pending-only
  const [requestsSubtab, setRequestsSubtab] = useState('skills') // 'skills' | 'catalog'
  const pendingCatalogCount = catalogRequests.filter(cr => cr.status === 'Requested').length
  const [confirmDeleteUserId, setConfirmDeleteUserId] = useState(null)
  const [confirmRequest, setConfirmRequest] = useState(null) // { person_id, skill_id, action: 'approve'|'reject' }
  const [logs, setLogs] = useState([])
  const [editUserSkill, setEditUserSkill] = useState(null) // { person_id, skill: {id}, level, years, frequency, notes, name, username }
  const [selectedUser, setSelectedUser] = useState(null)

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
        setPendingCount(reqRes.data.total || 0)
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

  // Close skills dropdown on outside click
  useEffect(() => {
    if (!showSkillsDropdown) return
    const handleClickOutside = (e) => {
      if (skillsDropdownRef.current && !skillsDropdownRef.current.contains(e.target)) {
        setShowSkillsDropdown(false)
      }
    }
    document.addEventListener('mousedown', handleClickOutside)
    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [showSkillsDropdown])

  const reloadRequests = async (page = requestsPage, status = 'Requested') => {
    try {
      const reqRes = await teamApi.getAdminRequests({ page, pageSize: 20, status })
      setRequests(reqRes.data.items || [])
      setRequestsTotal(reqRes.data.total || 0)
      setRequestsPage(page)
      
      // Update pending count if loading pending requests
      if (status === 'Requested') {
        setPendingCount(reqRes.data.total || 0)
      }
    } catch (err) {
      setError('Failed to load requests: ' + err.message)
    }
  }

  const [editingCatalogId, setEditingCatalogId] = useState(null)
  const [editCatalogForm, setEditCatalogForm] = useState({ skill_name: '', skill_type: 'Technology', justification: '' })
  const [savingCatalogEdit, setSavingCatalogEdit] = useState(false)

  const reloadCatalogRequests = async () => {
    try {
      const data = await getCatalogRequests()
      // Only show pending in subtab badge and default list
      setCatalogRequests(Array.isArray(data) ? data : [])
    } catch (err) {
      setError('Failed to load catalog requests: ' + err.message)
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
            Administer users and the skills catalog, review approval queues, and maintain platform data integrity.
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
            Search
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
            onClick={() => setActiveTab('requests')}
            className={`px-4 py-2 font-medium border-b-2 transition ${
              activeTab === 'requests'
                ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
            }`}
          >
            Requests {pendingCount > 0 ? `(${pendingCount})` : ''}
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
            <h2 className="text-xl font-semibold text-[var(--text-color)]">Search</h2>
            {/* Filters & Sorting */}
            <div className="mt-4 grid grid-cols-1 md:grid-cols-5 gap-3">
              <div className="md:col-span-1">
                <label className="block text-sm font-medium text-[var(--text-color)]">Name</label>
                <input
                  type="text"
                  value={userSearch}
                  onChange={(e) => setUserSearch(e.target.value)}
                  placeholder="Search by name or username"
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                />
              </div>
              <div className="relative md:col-span-2" ref={skillsDropdownRef}>
                <label className="block text-sm font-medium text-[var(--text-color)]">Skills</label>
                <input
                  type="text"
                  value={skillsSearch}
                  onChange={(e) => setSkillsSearch(e.target.value)}
                  onFocus={() => setShowSkillsDropdown(true)}
                  placeholder="Filter skills…"
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                />
                {showSkillsDropdown && (
                  <div className="absolute z-10 mt-1 w-full max-h-48 overflow-y-auto rounded-md border border-[var(--border-color)] bg-[var(--card-background)] shadow">
                    {skills
                      .filter(s => (skillsSearch.trim() === '' || (s.name || '').toLowerCase().includes(skillsSearch.trim().toLowerCase())))
                      .map(s => {
                        const checked = selectedSkills.includes(s.id)
                        return (
                          <label key={`skill-filter-${s.id}`} className="flex items-center gap-2 px-3 py-2 text-sm text-[var(--text-color)] hover:bg-[var(--background-muted)]">
                            <input
                              type="checkbox"
                              checked={checked}
                              onChange={(e) => {
                                setSelectedSkills(prev => {
                                  if (e.target.checked) return [...prev, s.id]
                                  return prev.filter(id => id !== s.id)
                                })
                              }}
                            />
                            <span>{s.name}</span>
                          </label>
                        )
                      })}
                    {skills.filter(s => (skillsSearch.trim() === '' || (s.name || '').toLowerCase().includes(skillsSearch.trim().toLowerCase()))).length === 0 && (
                      <p className="px-3 py-2 text-xs text-[var(--text-color-secondary)]">No matching skills.</p>
                    )}
                    <div className="flex items-center justify-end gap-2 px-3 py-2 border-t border-[var(--border-color)]">
                      <button type="button" onClick={() => setSelectedSkills([])} className="text-xs rounded border border-[var(--border-color)] px-2 py-1 hover:bg-[var(--background)]">Clear</button>
                    </div>
                  </div>
                )}
              </div>
              <div className="md:col-span-1">
                <label className="block text-sm font-medium text-[var(--text-color)]">Role</label>
                <select
                  value={userRoleFilter}
                  onChange={(e) => setUserRoleFilter(e.target.value)}
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-2 py-1.5 text-sm text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                >
                  <option value="all">All</option>
                  <option value="employee">Employee</option>
                  <option value="manager">Manager</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
              <div className="md:col-span-1">
                <label className="block text-sm font-medium text-[var(--text-color)]">Sort</label>
                <div className="mt-1 flex items-center gap-2">
                  <select
                    value={userSortField}
                    onChange={(e) => setUserSortField(e.target.value)}
                    className="flex-1 rounded-md border border-[var(--border-color)] bg-[var(--background)] px-2 py-1.5 text-sm text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                  >
                    <option value="name">Name</option>
                    <option value="id">ID</option>
                    <option value="skills">Skills Count</option>
                  </select>
                  <button
                    type="button"
                    aria-label="Toggle sort direction"
                    title={userSortDir === 'asc' ? 'Ascending' : 'Descending'}
                    onClick={() => setUserSortDir(prev => (prev === 'asc' ? 'desc' : 'asc'))}
                    className="rounded-md border border-[var(--border-color)] px-2 py-1.5 text-sm text-[var(--text-color)] hover:bg-[var(--background)] flex items-center justify-center"
                  >
                    {userSortDir === 'asc' ? (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 4l-4 4h3v8h2V8h3L8 4z" fill="currentColor"/>
                        <path d="M16 20l4-4h-3V8h-2v8h-3l4 4z" fill="currentColor"/>
                      </svg>
                    ) : (
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M8 20l-4-4h3V8h2v8h3l-4 4z" fill="currentColor"/>
                        <path d="M16 4l4 4h-3v8h-2V8h-3l4-4z" fill="currentColor"/>
                      </svg>
                    )}
                  </button>
                </div>
              </div>
            </div>
            {/* Selected skills chips inline */}
            {selectedSkills.length > 0 && (
              <div className="mt-2 flex flex-wrap gap-2">
                {selectedSkills.map(id => {
                  const sk = skills.find(s => s.id === id)
                  return (
                    <span key={`chip-${id}`} className="px-2 py-1 text-xs rounded border border-[var(--border-color)] bg-[var(--background)] text-[var(--text-color)]">
                      {sk?.name || `Skill ${id}`}
                    </span>
                  )
                })}
                <button type="button" onClick={() => setSelectedSkills([])} className="text-xs rounded border border-[var(--border-color)] px-2 py-1 hover:bg-[var(--background)]">Clear</button>
              </div>
            )}

            {/* Derived filtered + sorted list */}
            {(() => {
              const q = userSearch.trim().toLowerCase()
              const role = userRoleFilter
              const filtered = (users || []).filter(u => {
                const matchesQuery = q === '' || (u.name?.toLowerCase().includes(q) || u.username?.toLowerCase().includes(q))
                const matchesRole = role === 'all' || (u.role?.toLowerCase() === role)
                // Skills filter: backend now provides `user.skills: [{id, name}]`
                const userSkillIds = new Set(
                  Array.isArray(u.skills) ? u.skills.map(sk => sk?.id).filter(id => id != null) : []
                )
                // AND matching: user must have ALL selected skills to pass
                const hasSelected = selectedSkills.length === 0 || selectedSkills.every(id => userSkillIds.has(id))
                return matchesQuery && matchesRole && hasSelected
              })
              const sorted = filtered.sort((a, b) => {
                let cmp = 0
                if (userSortField === 'name') {
                  cmp = (a.name || '').localeCompare(b.name || '')
                } else if (userSortField === 'id') {
                  cmp = (a.person_id || 0) - (b.person_id || 0)
                } else if (userSortField === 'skills') {
                  const ac = Array.isArray(a.skills) ? a.skills.length : (a.skills_count || 0)
                  const bc = Array.isArray(b.skills) ? b.skills.length : (b.skills_count || 0)
                  cmp = ac - bc
                }
                return userSortDir === 'asc' ? cmp : -cmp
              })
              return (
                <div className="mt-4 space-y-2 max-h-[70vh] overflow-y-auto">
                  {sorted.map((user) => (
                    <div
                      key={user.person_id}
                      onClick={() => setSelectedUser(user)}
                      className="flex items-center justify-between rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4 cursor-pointer hover:bg-[var(--background)]"
                      role="button"
                      tabIndex={0}
                      onKeyDown={(e) => { if (e.key === 'Enter') setSelectedUser(user) }}
                    >
                      <div>
                        <p className="font-medium text-[var(--text-color)]">{user.name}</p>
                        <p className="text-sm text-[var(--text-color-secondary)]">ID: {user.person_id} • Role: {user.role}</p>
                      </div>
                    </div>
                  ))}
                  {sorted.length === 0 && (
                    <div className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4">
                      <p className="text-sm text-[var(--text-color-secondary)]">No users match your filters.</p>
                    </div>
                  )}
                </div>
              )
            })()}
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
              <div className="mt-4 space-y-2 max-h-[70vh] overflow-y-auto">
                {skills.map((skill) => (
                  <div
                    key={skill.id}
                    className="flex items-center justify-between rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4"
                  >
                    <div>
                      <p className="font-medium text-[var(--text-color)]">{skill.name}</p>
                      <p className="text-sm text-[var(--text-color-secondary)]">Type: {skill.type}</p>
                    </div>
                    <button
                      onClick={() => handleDeleteSkill(skill.id)}
                      className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
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
                          <p className="text-sm text-[var(--text-color-secondary)]">Level: <span className={`px-2 py-0.5 rounded text-xs font-semibold ${levelClasses(r.level)}`}>{r.level}</span></p>
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
                        onClick={() => setEditUserSkill({ person_id: r.person_id, skill: r.skill, level: r.level, years: r.years, frequency: r.frequency, notes: r.notes, name: r.name, username: r.username })}
                        className="px-3 py-1.5 text-sm rounded border border-[var(--border-color)] text-[var(--text-color)]"
                      >
                        Edit
                      </button>
                      <button
                        onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'delete' })}
                        className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                ))
              )}
            </div>
          </section>
        ) : activeTab === 'requests' ? (
          <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-semibold text-[var(--text-color)]">Pending Requests</h2>
              <div />
            </div>

            {/* Subtabs for Approval Queue */}
            <div className="mt-4 flex gap-2 border-b border-[var(--border-color)]">
              <button
                onClick={async () => { setRequestsSubtab('skills'); await reloadRequests(1, 'Requested') }}
                className={`px-3 py-1.5 text-sm font-medium border-b-2 transition ${
                  requestsSubtab === 'skills'
                    ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                    : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
                }`}
              >
                Skill Requests
              </button>
              <button
                onClick={async () => { setRequestsSubtab('catalog'); await reloadCatalogRequests() }}
                className={`px-3 py-1.5 text-sm font-medium border-b-2 transition ${
                  requestsSubtab === 'catalog'
                    ? 'border-[var(--color-primary)] text-[var(--color-primary)]'
                    : 'border-transparent text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
                }`}
              >
                Catalog Requests {pendingCatalogCount > 0 ? `(${pendingCatalogCount})` : ''}
              </button>
            </div>

            {/* Skill Requests list (legacy-style to match catalog) */}
            {requestsSubtab === 'skills' && (
              <div className="mt-3 space-y-2">
                {requests.length === 0 ? (
                  <p className="text-base text-[var(--text-color-secondary)]">All skill requests are up to date.</p>
                ) : (
                  requests.map((r) => (
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
                            Requested by {r.name} ({r.username})
                            {r.requested_at && (
                              <span> {timeAgo(r.requested_at)}</span>
                            )}
                          </p>
                        </div>
                        <div className="text-right flex flex-col items-end gap-1">
                          {r.years !== null && r.years !== undefined && (
                            <p className="text-sm text-[var(--text-color-secondary)]">Experience: {r.years} yrs</p>
                          )}
                          {r.frequency && (
                            <p className="text-sm text-[var(--text-color-secondary)]">Frequency: {r.frequency}</p>
                          )}
                        </div>
                      </div>

                      {/* Details grid similar to catalog justification area */}
                      <div className="mt-0 grid grid-cols-1 gap-2 sm:grid-cols-2 text-sm text-[var(--text-color-secondary)]">
                        {r.level && (
                          <div className="flex items-center gap-1">
                            <span className="font-medium">Level:</span>
                            <span className={`px-2 py-0.5 rounded ${levelClasses(r.level)}`}>{r.level}</span>
                          </div>
                        )}
                        {/* Frequency moved to top-right header */}
                      </div>
                      <p className="text-base text-[var(--text-color-secondary)]">{r.notes?.trim() || 'No notes provided.'}</p>

                      <div className="flex flex-wrap gap-2 justify-end">
                        <button
                          type="button"
                          onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'approve' })}
                          className="rounded-md border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-sm font-semibold text-emerald-700 transition hover:bg-emerald-100"
                        >
                          Approve
                        </button>
                        <button
                          type="button"
                          onClick={() => setConfirmRequest({ person_id: r.person_id, skill_id: r.skill.id, action: 'reject' })}
                          className="rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100"
                        >
                          Reject
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>
            )}

            {/* Catalog Requests list (legacy style) */}
            {requestsSubtab === 'catalog' && (
              <div className="mt-3 space-y-2">
                {catalogRequests.filter(cr => cr.status === 'Requested').length === 0 ? (
                  <p className="text-base text-[var(--text-color-secondary)]">All catalog requests are up to date.</p>
                ) : (
                  catalogRequests
                    .filter(cr => cr.status === 'Requested')
                    .map((cr) => {
                      const busy = savingCatalogEdit && editingCatalogId === cr.request_id
                      const inEditMode = editingCatalogId === cr.request_id
                      return (
                        <div key={`catalog-${cr.request_id}`} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-3 space-y-2">
                          <div className="flex flex-col gap-2 sm:flex-row sm:items-start sm:justify-between">
                            <div className="flex-1">
                              <p className="text-lg font-semibold text-[var(--text-color)]">
                                {cr.skill_name}
                                {cr.skill_type && (
                                  <span className="ml-2 text-sm font-normal text-[var(--text-color-secondary)]">• {cr.skill_type}</span>
                                )}
                              </p>
                              <p className="text-sm text-[var(--text-color-secondary)]">
                                Requested by {cr.requested_by_name || cr.requested_by}
                                {cr.created_at && (
                                  <span> {new Date(cr.created_at).toLocaleString('en-US', { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' })}</span>
                                )}
                              </p>
                            </div>
                            <div />
                          </div>

                          {inEditMode ? (
                            <div className="space-y-2 rounded border border-dashed border-[var(--border-color)] bg-[var(--background)] p-3">
                              <label className="text-sm font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                                Skill Name
                                <input
                                  name="skill_name"
                                  value={editCatalogForm.skill_name}
                                  onChange={(e) => setEditCatalogForm(prev => ({ ...prev, skill_name: e.target.value }))}
                                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-base text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                                />
                              </label>
                              <label className="text-sm font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                                Category
                                <select
                                  name="skill_type"
                                  value={editCatalogForm.skill_type}
                                  onChange={(e) => setEditCatalogForm(prev => ({ ...prev, skill_type: e.target.value }))}
                                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-base text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                                >
                                  <option>Technology</option>
                                  <option>Knowledge</option>
                                  <option>Experience</option>
                                  <option>Other</option>
                                </select>
                              </label>
                              <label className="text-sm font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                                Justification
                                <textarea
                                  name="justification"
                                  rows="3"
                                  value={editCatalogForm.justification}
                                  onChange={(e) => setEditCatalogForm(prev => ({ ...prev, justification: e.target.value }))}
                                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-base text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                                />
                              </label>
                              <div className="flex flex-wrap gap-2">
                                <button
                                  type="button"
                                  disabled={busy}
                                  onClick={async () => {
                                    try {
                                      setSavingCatalogEdit(true)
                                      // Update request fields then approve
                                      if (updateCatalogRequest) {
                                        await updateCatalogRequest(editingCatalogId, {
                                          skill_name: editCatalogForm.skill_name.trim(),
                                          skill_type: editCatalogForm.skill_type,
                                          justification: editCatalogForm.justification,
                                        })
                                      }
                                      await processCatalogRequest(editingCatalogId, { action: 'approve' })
                                      setEditingCatalogId(null)
                                      setEditCatalogForm({ skill_name: '', skill_type: 'Technology', justification: '' })
                                      await reloadCatalogRequests()
                                      showToast('Catalog request approved', { variant: 'success' })
                                    } catch (err) {
                                      setError('Approve failed: ' + err.message)
                                      showToast('Approve failed: ' + err.message, { variant: 'error' })
                                    } finally {
                                      setSavingCatalogEdit(false)
                                    }
                                  }}
                                  className={`rounded-md border border-[color:var(--color-primary)] px-3 py-1.5 text-sm font-semibold text-[color:var(--color-primary)] transition hover:bg-[var(--color-primary)]/10 ${busy ? 'opacity-60' : ''}`}
                                >
                                  {busy ? 'Saving...' : 'Save & Approve'}
                                </button>
                                <button
                                  type="button"
                                  onClick={() => { setEditingCatalogId(null); setEditCatalogForm({ skill_name: '', skill_type: 'Technology', justification: '' }) }}
                                  className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm font-semibold text-[var(--text-color-secondary)] hover:bg-[var(--background)]"
                                >
                                  Cancel
                                </button>
                              </div>
                            </div>
                          ) : (
                            <p className="text-base text-[var(--text-color-secondary)]">{cr.justification?.trim() || 'No justification provided.'}</p>
                          )}

                          <div className="flex flex-wrap gap-2 justify-end">
                            <button
                              type="button"
                              disabled={busy || inEditMode}
                              onClick={() => {
                                setEditingCatalogId(cr.request_id)
                                setEditCatalogForm({
                                  skill_name: cr.skill_name || '',
                                  skill_type: cr.skill_type || 'Technology',
                                  justification: cr.justification || '',
                                })
                              }}
                              className={`rounded-md border border-emerald-200 bg-emerald-50 px-3 py-1.5 text-sm font-semibold text-emerald-700 transition hover:bg-emerald-100 ${busy || inEditMode ? 'opacity-60' : ''}`}
                            >
                              Approve
                            </button>
                            <button
                              type="button"
                              disabled={busy || inEditMode}
                              onClick={async () => { try { await processCatalogRequest(cr.request_id, { action: 'reject' }); await reloadCatalogRequests(); showToast('Catalog request rejected', { variant: 'success' }) } catch (err) { setError('Reject failed: ' + err.message); showToast('Reject failed: ' + err.message, { variant: 'error' }) } }}
                              className={`rounded-md border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-semibold text-rose-700 transition hover:bg-rose-100 ${busy || inEditMode ? 'opacity-60' : ''}`}
                            >
                              Reject
                            </button>
                          </div>
                        </div>
                      )
                    })
                )}
              </div>
            )}

            {requestsSubtab === 'skills' && (
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
            )}
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
                  <div key={`log-${r.status}-${r.person_id}-${r.skill.id}`} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4 flex items-start gap-4">
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

      {/* User Summary Modal */}
      {selectedUser && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-6">
          <div className="w-full max-w-3xl rounded-2xl bg-[var(--card-background)] p-8 shadow-2xl">
            {/* Header */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="h-14 w-14 rounded-full bg-[var(--background-muted)] flex items-center justify-center text-base font-semibold text-[var(--text-color)]">
                  {(selectedUser.name || selectedUser.username || 'U').slice(0,2).toUpperCase()}
                </div>
                <div>
                  <h3 className="text-2xl font-semibold text-[var(--text-color)]">{selectedUser.name || 'User'}</h3>
                  <p className="text-base text-[var(--text-color-secondary)]">@{selectedUser.username} • {selectedUser.role || 'Role'}</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setSelectedUser(null)}
                className="rounded-md px-4 py-2 text-base font-medium text-[var(--text-color-secondary)] hover:text-[color:var(--color-primary)]"
              >
                Close
              </button>
            </div>

            {/* Body */}
            <div className="mt-6 grid grid-cols-1 md:grid-cols-3 gap-6">
              {/* Overview */}
              <div className="md:col-span-1 rounded-xl border border-[var(--border-color)] bg-[var(--background-muted)] p-5">
                <div className="space-y-3 text-base">
                  <div className="flex items-center justify-between">
                    <span className="text-[var(--text-color-secondary)]">ID</span>
                    <span className="font-semibold text-[var(--text-color)]">{selectedUser.person_id}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-[var(--text-color-secondary)]">Role</span>
                    <span className="font-semibold text-[var(--text-color)]">{selectedUser.role || '—'}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-[var(--text-color-secondary)]">Manager</span>
                    <span className="font-semibold text-[var(--text-color)]">
                      {(() => {
                        const managerPid = selectedUser.manager_person_id || selectedUser.manager_id || selectedUser.managerId
                        if (managerPid) {
                          const mgr = (users || []).find(u => u.person_id === managerPid)
                          if (mgr) {
                            return mgr.name || '—'
                          }
                          // No match found badge
                          return (
                            <span className="inline-flex items-center gap-2">
                              <span>—</span>
                              <span className="text-xs rounded bg-[var(--background)] px-2 py-0.5 text-[var(--text-color-secondary)]">unmatched ID {managerPid}</span>
                            </span>
                          )
                        }
                        return selectedUser.superior
                          || selectedUser.manager_name
                          || selectedUser.manager
                          || selectedUser.manager_username
                          || '—'
                      })()}
                    </span>
                  </div>
                  {selectedUser.email && (
                    <div className="flex items-start justify-between gap-2">
                      <span className="text-[var(--text-color-secondary)]">Email</span>
                      <span className="font-semibold text-[var(--text-color)] break-all">{selectedUser.email}</span>
                    </div>
                  )}
                </div>
              </div>

              {/* Skills */}
              <div className="md:col-span-2 rounded-xl border border-[var(--border-color)] bg-[var(--background-muted)] p-5">
                <div className="flex items-center justify-between">
                  <p className="text-base font-semibold text-[var(--text-color)]">Skills</p>
                  <span className="text-sm rounded bg-[var(--background)] px-3 py-1 text-[var(--text-color-secondary)]">
                    {Array.isArray(selectedUser.skills) ? selectedUser.skills.length : (selectedUser.skills_count || 0)} total
                  </span>
                </div>
                {Array.isArray(selectedUser.skills) && selectedUser.skills.length > 0 ? (
                  <div className="mt-4 flex flex-wrap gap-3">
                    {selectedUser.skills.map(s => (
                      <span key={s.id} className="text-sm rounded-md border border-[var(--border-color)] bg-[var(--card-background)] px-3 py-1.5 text-[var(--text-color)]">
                        {s.name}
                      </span>
                    ))}
                  </div>
                ) : (
                  <p className="mt-4 text-sm text-[var(--text-color-secondary)]">No skills listed.</p>
                )}
              </div>
            </div>

            {/* Footer */}
            <div className="mt-8 flex justify-between gap-3">
              <div />
              <div className="flex gap-2">
                {String(selectedUser.role || '').toLowerCase() !== 'admin' && (
                  <button
                    type="button"
                    onClick={() => { setSelectedUser(null); setConfirmDeleteUserId(selectedUser.person_id) }}
                    className="rounded-md border border-rose-200 bg-rose-50 px-5 py-2.5 text-base font-semibold text-rose-700 transition hover:bg-rose-100"
                    title="Delete this user"
                  >
                    Delete User
                  </button>
                )}
                <button
                  type="button"
                  onClick={() => setSelectedUser(null)}
                  className="rounded-md border border-[var(--border-color)] px-5 py-2.5 text-base font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
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

      {/* Edit User Skill Modal */}
      {editUserSkill && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-xl rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-xl font-semibold text-[var(--text-color)]">Edit Approved Skill</h3>
                <p className="text-sm text-[var(--text-color-secondary)]">{editUserSkill.name} • {editUserSkill.username}</p>
              </div>
              <button type="button" onClick={() => setEditUserSkill(null)} className="rounded-md px-3 py-1.5 text-sm font-medium text-[var(--text-color-secondary)] hover:text-[color:var(--color-primary)]">Close</button>
            </div>
            <form className="mt-4 space-y-4" onSubmit={async (e) => {
              e.preventDefault()
              try {
                await teamApi.updateUserSkillDetails(editUserSkill.person_id, editUserSkill.skill.id, {
                  level: editUserSkill.level,
                  years: editUserSkill.years,
                  frequency: editUserSkill.frequency,
                  notes: editUserSkill.notes,
                })
                setEditUserSkill(null)
                await reloadRequests(1, 'Approved')
              } catch (err) {
                setError('Failed to update skill: ' + err.message)
              }
            }}>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <label className="text-sm font-medium text-[var(--text-color)]">
                  Proficiency
                  <select value={editUserSkill.level || 'Intermediate'} onChange={(e) => setEditUserSkill(prev => ({ ...prev, level: e.target.value }))} className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none">
                    <option>Beginner</option>
                    <option>Intermediate</option>
                    <option>Advanced</option>
                    <option>Expert</option>
                  </select>
                </label>
                <label className="text-sm font-medium text-[var(--text-color)]">
                  Years Experience
                  <input type="number" min="0" value={editUserSkill.years || 0} onChange={(e) => setEditUserSkill(prev => ({ ...prev, years: Number(e.target.value) }))} className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none" />
                </label>
              </div>
              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <label className="text-sm font-medium text-[var(--text-color)]">
                  Frequency
                  <select value={editUserSkill.frequency || 'Weekly'} onChange={(e) => setEditUserSkill(prev => ({ ...prev, frequency: e.target.value }))} className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none">
                    <option>Daily</option>
                    <option>Weekly</option>
                    <option>Monthly</option>
                    <option>Occasionally</option>
                  </select>
                </label>
              </div>
              <label className="block text-sm font-medium text-[var(--text-color)]">
                Notes
                <textarea rows="3" value={editUserSkill.notes || ''} onChange={(e) => setEditUserSkill(prev => ({ ...prev, notes: e.target.value }))} className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none" />
              </label>
              <div className="flex justify-end gap-3 pt-2">
                <button type="button" onClick={() => setEditUserSkill(null)} className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]">Cancel</button>
                <button type="submit" className="rounded-md bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[color:var(--color-primary-dark)]">Save Changes</button>
              </div>
            </form>
          </div>
        </div>
      )}
      </main>
    </div>
  )
}
