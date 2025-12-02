// Admin.jsx
// Admin dashboard with user and skill management.

import { useState, useEffect, useMemo, useCallback } from 'react'
import Sidebar from '@/components/Sidebar'
import BackupHealthStatus from '@/components/visuals/BackupHealthStatus'
import DataVolumeCounters from '@/components/visuals/DataVolumeCounters'
import ExportSummaryCounters from '@/components/visuals/ExportSummaryCounters'
import SearchResultCards from '@/components/visuals/SearchResultCards'
import StatusBadges from '@/components/visuals/StatusBadges'
import usersApi from '@/api/usersApi'
import skillsApi from '@/api/skillsApi'
import personSkillsApi from '@/api/personSkillsApi'
import skillRequestsApi from '@/api/skillRequestsApi'

export default function Admin() {
  const [users, setUsers] = useState([])
  const [skills, setSkills] = useState([])
  const [skillRequests, setSkillRequests] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [activeTab, setActiveTab] = useState('users') // 'users' or 'skills'
  const [newSkillForm, setNewSkillForm] = useState({ skill_name: '', skill_type: 'Technology' })
  const [reviewActionKey, setReviewActionKey] = useState(null)
  const [reviewActionError, setReviewActionError] = useState(null)
  const [requestActionKey, setRequestActionKey] = useState(null)
  const [requestActionError, setRequestActionError] = useState(null)
  const [editingRequestId, setEditingRequestId] = useState(null)
  const [editRequestForm, setEditRequestForm] = useState({ skill_name: '', skill_type: 'Technology', justification: '' })
  const [editSaving, setEditSaving] = useState(false)

  const fetchData = useCallback(async ({ withLoader = true } = {}) => {
    try {
      if (withLoader) {
        setLoading(true)
        setError(null)
      }

      const [usersRes, skillsRes, skillRequestsRes] = await Promise.all([
        usersApi.getAllUsers(),
        skillsApi.getAllSkills(),
        skillRequestsApi.listRequests(),
      ])

      setUsers(usersRes.data || [])
      setSkills(skillsRes.data || [])
      setSkillRequests(skillRequestsRes.data || [])
    } catch (err) {
      setError('Failed to load data: ' + err.message)
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
    fetchData()
  }, [fetchData])

  const isPendingStatus = (status) => ['pending', 'requested'].includes(status?.toLowerCase?.())

  const backupSnapshot = useMemo(() => {
    const totalRecords = users.length + skills.length
    const protectedRecords = Math.max(0, Math.round(totalRecords * 0.9))
    const changeEvents = users.length * 3 + skills.length
    const changesSinceBackup = Math.max(0, changeEvents - protectedRecords)

    return {
      protectedRecords,
      changesSinceBackup,
    }
  }, [skills.length, users.length])

  const pendingCatalogRequests = useMemo(
    () => skillRequests.filter((request) => isPendingStatus(request.status)),
    [skillRequests],
  )

  const recentCatalogHistory = useMemo(() => {
    return skillRequests
      .filter((request) => !isPendingStatus(request.status))
      .sort((a, b) => new Date(b.resolved_at || b.created_at) - new Date(a.resolved_at || a.created_at))
      .slice(0, 5)
  }, [skillRequests])

  const formatTimestamp = (value) => {
    if (!value) return '—'
    try {
      return new Date(value).toLocaleString('en-US', {
        month: 'short',
        day: 'numeric',
        hour: 'numeric',
        minute: '2-digit',
      })
    } catch (_) {
      return value
    }
  }

  const platformVolumes = useMemo(() => {
    const organizationIds = users
      .map((u) => u.organization_id ?? u.member_of_organization_id)
      .filter((value) => value !== null && value !== undefined)

    return {
      skills: skills.length,
      employees: users.length,
      teams: new Set(organizationIds).size,
      audits: backupSnapshot.changesSinceBackup,
    }
  }, [backupSnapshot.changesSinceBackup, skills.length, users])

  const backupStatusCard = useMemo(() => ({
    lastBackup: new Date().toLocaleString('en-US', { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' }),
    status: users.length > 0 ? 'healthy' : 'warning',
    message: `${backupSnapshot.protectedRecords.toLocaleString('en-US')} records protected in archive`,
  }), [backupSnapshot.protectedRecords, users.length])

  const exportSummary = useMemo(() => ({
    files: Math.max(1, Math.round(users.length / 25) || 1),
    rows: users.length + skills.length,
    duration: users.length ? `${Math.max(2, Math.round((users.length + skills.length) / 20))}s` : '—',
  }), [skills.length, users.length])

  const reviewQueue = useMemo(() => {
    const normalizePendingSkills = (user) => {
      const rawSkills = Array.isArray(user.pending_skills)
        ? user.pending_skills
        : Array.isArray(user.pendingSkills)
          ? user.pendingSkills
          : []

      return rawSkills
        .map((skill) => {
          if (!skill) return null
          if (typeof skill === 'string') {
            return {
              id: skill,
              name: skill,
              type: 'Skill request',
              requestedAt: null,
              proficiencyLevel: null,
              usageFrequency: null,
              experienceYears: null,
              notes: '',
            }
          }

          const requestedAt = skill.requested_at ?? skill.requestedAt ?? null
          const experienceValue = skill.experience_years ?? skill.experienceYears ?? null
          let experienceYears = null
          if (experienceValue !== null && experienceValue !== undefined && experienceValue !== '') {
            const parsedExperience = typeof experienceValue === 'number' ? experienceValue : Number(experienceValue)
            experienceYears = Number.isNaN(parsedExperience) ? null : parsedExperience
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

    const pendingEntries = users
      .map((user) => {
        const pendingSkillsList = normalizePendingSkills(user)
        const pendingCount = pendingSkillsList.length || user.pending_skills_count || 0

        const pendingTimestamps = pendingSkillsList
          .map((skill) => skill?.requestedAt)
          .map((value) => {
            if (!value) return null
            const timestamp = new Date(value).getTime()
            return Number.isNaN(timestamp) ? null : timestamp
          })
          .filter((value) => value !== null)

        const oldestPending = pendingTimestamps.length ? Math.min(...pendingTimestamps) : null

        return {
          user,
          pendingSkillsList,
          pendingCount,
          oldestPending,
        }
      })
      .filter((entry) => entry.pendingCount > 0)
      .sort((a, b) => {
        const aTime = a.oldestPending ?? Number.POSITIVE_INFINITY
        const bTime = b.oldestPending ?? Number.POSITIVE_INFINITY
        if (aTime !== bTime) return aTime - bTime
        return b.pendingCount - a.pendingCount
      })
      .map((entry) => ({
        id: entry.user.person_id,
        name: entry.user.name,
        role: entry.user.role,
        status: 'pending',
        pendingCount: entry.pendingCount,
        waitTimestamp: entry.oldestPending,
        skills: entry.pendingSkillsList,
      }))

    return pendingEntries
  }, [users])

  const handleDeleteUser = async (userId) => {
    if (!window.confirm('Are you sure you want to delete this user?')) return

    try {
      await usersApi.deleteUser(userId)
      setUsers((prev) => prev.filter((u) => u.person_id !== userId))
      setError(null)
    } catch (err) {
      setError('Failed to delete user: ' + err.message)
    }
  }

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

  const handleSkillRequestAction = async (request, action) => {
    if (!request?.request_id) return
    setRequestActionKey(request.request_id)
    setRequestActionError(null)
    setEditingRequestId(null)
    try {
      await skillRequestsApi.resolveRequest(request.request_id, { action })
      await fetchData({ withLoader: false })
    } catch (err) {
      console.error('Failed to update catalog request:', err)
      setRequestActionError(err.response?.data?.error || err.message || 'Failed to update catalog request.')
    } finally {
      setRequestActionKey(null)
    }
  }

  const startEditingRequest = (request) => {
    if (!request) return
    setRequestActionError(null)
    setEditingRequestId(request.request_id)
    setEditRequestForm({
      skill_name: request.skill_name || '',
      skill_type: request.skill_type || 'Technology',
      justification: request.justification || '',
    })
  }

  const cancelEditRequest = () => {
    setEditingRequestId(null)
    setEditRequestForm({ skill_name: '', skill_type: 'Technology', justification: '' })
    setEditSaving(false)
  }

  const handleEditFieldChange = (event) => {
    const { name, value } = event.target
    setEditRequestForm((prev) => ({ ...prev, [name]: value }))
  }

  const saveEditedRequest = async () => {
    if (!editingRequestId) return
    if (!editRequestForm.skill_name.trim()) {
      setRequestActionError('Skill name is required before saving edits.')
      return
    }

    setEditSaving(true)
    setRequestActionError(null)
    try {
      await skillRequestsApi.updateRequest(editingRequestId, {
        skill_name: editRequestForm.skill_name.trim(),
        skill_type: editRequestForm.skill_type,
        justification: editRequestForm.justification,
      })
      await fetchData({ withLoader: false })
      cancelEditRequest()
    } catch (err) {
      console.error('Failed to edit catalog request:', err)
      setRequestActionError(err.response?.data?.error || err.message || 'Failed to save edits for the request.')
    } finally {
      setEditSaving(false)
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

  const handleReviewResolution = async (item, skill, nextStatus) => {
    const userId = item?.id ?? item?.person_id
    const skillId = skill?.id ?? skill?.skill_id
    if (!userId || !skillId) return

    const actionKey = `${userId}-${skillId}`
    setReviewActionKey(actionKey)
    setReviewActionError(null)
    try {
      await personSkillsApi.updateUserSkill(userId, skillId, { status: nextStatus })
      await fetchData({ withLoader: false })
    } catch (err) {
      console.error('Failed to update skill status:', err)
      setReviewActionError(err.message || 'Failed to update the skill request.')
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
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Admin UI</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">Platform Administration</h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">
            Manage users, skills, and platform settings. 
          </p>
        </header>

        {!loading && (
          <section className="space-y-4">
            <div className="grid gap-4 lg:grid-cols-3">
              <div className="lg:col-span-2">
                <DataVolumeCounters items={platformVolumes} auditLabel="Audits" />
              </div>
              <div className="space-y-2">
                <BackupHealthStatus {...backupStatusCard} />
                <p className="text-xs text-[var(--text-color-secondary)]">Backup health status is illustrative placeholder data.</p>
              </div>
            </div>

            <div className="grid gap-4 lg:grid-cols-3">
              <div className="space-y-2">
                <ExportSummaryCounters summary={exportSummary} />
                <p className="text-xs text-[var(--text-color-secondary)]">Export summary metrics are placeholders until real exports are wired up.</p>
              </div>
              <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4 lg:col-span-2">
                <div>
                  <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Review Queue</p>
                  <h2 className="text-xl font-semibold text-[var(--text-color)]">Pending Actions</h2>
                  <p className="text-sm text-[var(--text-color-secondary)]">Spot checks for user updates awaiting approval.</p>
                  {reviewActionError && (
                    <p className="mt-2 text-sm text-red-600">{reviewActionError}</p>
                  )}
                </div>
                <div className="max-h-[34rem] overflow-y-auto pr-2">
                  <SearchResultCards
                    results={reviewQueue}
                    onResolveSkill={handleReviewResolution}
                    pendingActionKey={reviewActionKey}
                  />
                </div>
              </div>
            </div>

            <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm space-y-4">
              <div>
                <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Catalog Intake</p>
                <h2 className="text-xl font-semibold text-[var(--text-color)]">New Skill Requests</h2>
                <p className="text-sm text-[var(--text-color-secondary)]">Approve or reject brand-new catalog submissions.</p>
                {requestActionError && (
                  <p className="mt-2 text-sm text-red-600">{requestActionError}</p>
                )}
              </div>

              <div className="max-h-[30rem] space-y-3 overflow-y-auto pr-2">
                {pendingCatalogRequests.length === 0 ? (
                  <p className="text-sm text-[var(--text-color-secondary)]">All catalog requests are up to date.</p>
                ) : (
                  pendingCatalogRequests.map((request) => {
                    const busy = requestActionKey === request.request_id
                    const inEditMode = editingRequestId === request.request_id
                    return (
                      <div key={request.request_id} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4 space-y-3">
                        <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                          <div>
                            <p className="text-base font-semibold text-[var(--text-color)]">{request.skill_name}</p>
                            <p className="text-xs text-[var(--text-color-secondary)]">{request.skill_type} • Requested by {request.requested_by_name}</p>
                            <p className="text-xs text-[var(--text-color-secondary)]">Submitted {formatTimestamp(request.created_at)}</p>
                          </div>
                          <StatusBadges status={request.status?.toLowerCase?.() || 'requested'} />
                        </div>

                        {inEditMode ? (
                          <div className="space-y-3 rounded border border-dashed border-[var(--border-color)] bg-[var(--background)] p-3">
                            <label className="text-xs font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                              Skill Name
                              <input
                                name="skill_name"
                                value={editRequestForm.skill_name}
                                onChange={handleEditFieldChange}
                                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-sm text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                              />
                            </label>
                            <label className="text-xs font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                              Category
                              <select
                                name="skill_type"
                                value={editRequestForm.skill_type}
                                onChange={handleEditFieldChange}
                                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-sm text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                              >
                                <option>Technology</option>
                                <option>Knowledge</option>
                                <option>Experience</option>
                                <option>Other</option>
                              </select>
                            </label>
                            <label className="text-xs font-semibold uppercase tracking-wide text-[var(--text-color-secondary)]">
                              Justification
                              <textarea
                                name="justification"
                                rows="3"
                                value={editRequestForm.justification}
                                onChange={handleEditFieldChange}
                                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-transparent px-3 py-2 text-sm text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                              />
                            </label>
                            <div className="flex flex-wrap gap-2">
                              <button
                                type="button"
                                disabled={editSaving}
                                onClick={saveEditedRequest}
                                className={`rounded-md border border-[color:var(--color-primary)] px-3 py-1 text-sm font-semibold text-[color:var(--color-primary)] transition hover:bg-[var(--color-primary)]/10 ${editSaving ? 'opacity-60' : ''}`}
                              >
                                {editSaving ? 'Saving...' : 'Save Changes'}
                              </button>
                              <button
                                type="button"
                                onClick={cancelEditRequest}
                                className="rounded-md border border-[var(--border-color)] px-3 py-1 text-sm font-semibold text-[var(--text-color-secondary)] hover:bg-[var(--background)]"
                              >
                                Cancel
                              </button>
                            </div>
                          </div>
                        ) : (
                          <p className="text-sm text-[var(--text-color-secondary)]">
                            {request.justification?.trim() || 'No justification provided.'}
                          </p>
                        )}

                        <div className="flex flex-wrap gap-2">
                          <button
                            type="button"
                            disabled={busy || inEditMode}
                            onClick={() => handleSkillRequestAction(request, 'approve')}
                            className={`rounded-md border border-emerald-200 bg-emerald-50 px-3 py-1 text-sm font-semibold text-emerald-700 transition hover:bg-emerald-100 ${busy || inEditMode ? 'opacity-60' : ''}`}
                          >
                            {busy ? 'Saving...' : 'Approve & Add'}
                          </button>
                          <button
                            type="button"
                            disabled={busy || inEditMode}
                            onClick={() => handleSkillRequestAction(request, 'reject')}
                            className={`rounded-md border border-rose-200 bg-rose-50 px-3 py-1 text-sm font-semibold text-rose-700 transition hover:bg-rose-100 ${busy || inEditMode ? 'opacity-60' : ''}`}
                          >
                            {busy ? 'Saving...' : 'Reject'}
                          </button>
                          {!inEditMode && (
                            <button
                              type="button"
                              onClick={() => startEditingRequest(request)}
                              className="rounded-md border border-[var(--border-color)] px-3 py-1 text-sm font-semibold text-[var(--text-color-secondary)] hover:bg-[var(--background)]"
                            >
                              Edit
                            </button>
                          )}
                        </div>
                      </div>
                    )
                  })
                )}
              </div>

              {recentCatalogHistory.length > 0 && (
                <div className="space-y-3 border-t border-[var(--border-color)] pt-4">
                  <div className="flex items-center justify-between">
                    <p className="text-sm font-semibold text-[var(--text-color)]">Recent decisions</p>
                    <p className="text-xs text-[var(--text-color-secondary)]">Showing {recentCatalogHistory.length} most recent</p>
                  </div>
                  <ul className="space-y-2">
                    {recentCatalogHistory.map((request) => (
                      <li key={`history-${request.request_id}`} className="flex flex-wrap items-start justify-between gap-3 rounded-md border border-[var(--border-color)] bg-[var(--background)] p-3 text-sm">
                        <div>
                          <p className="font-medium text-[var(--text-color)]">{request.skill_name}</p>
                          <p className="text-xs text-[var(--text-color-secondary)]">{request.skill_type} • {request.requested_by_name}</p>
                          <p className="text-xs text-[var(--text-color-secondary)]">
                            {request.resolution_notes?.trim() ? `Notes: ${request.resolution_notes}` : 'No resolution notes.'}
                          </p>
                        </div>
                        <div className="text-right space-y-1">
                          <StatusBadges status={request.status?.toLowerCase?.() || 'approved'} />
                          <p className="text-xs text-[var(--text-color-secondary)]">{formatTimestamp(request.resolved_at)}</p>
                        </div>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </section>
        )}

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
        ) : (
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
        )}
      </main>
    </div>
  )
}
