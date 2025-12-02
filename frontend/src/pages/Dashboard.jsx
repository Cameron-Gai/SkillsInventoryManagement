// Dashboard.jsx
// Employee Dashboard is the base experience available to all roles.

import { useMemo, useState, useEffect } from 'react'
import Sidebar from '@/components/Sidebar'
import EmployeeSkillsPanel from '@/components/skills/EmployeeSkillsPanel'
import DesirableNote from '@/components/skills/DesirableNote'
import usersApi from '@/api/usersApi'
import { storeUser } from '@/utils/auth'

const formatNumber = (value) => new Intl.NumberFormat().format(Number(value ?? 0))

export default function Dashboard() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true)
        const response = await usersApi.getProfile()
        setUser(response.data)
        storeUser({
          person_id: response.data.person_id,
          role: response.data.role || (response.data.is_admin ? 'admin' : 'employee'),
          name: response.data.name,
          username: response.data.username,
          has_direct_reports: response.data.has_direct_reports ?? false,
          direct_report_count: response.data.direct_report_count ?? 0,
        })
        setError(null)
      } catch (err) {
        setError('Failed to load user profile')
        console.error('Error fetching user:', err)
        setUser(null)
      } finally {
        setLoading(false)
      }
    }

    fetchUser()
  }, [])

  const heroCopy = useMemo(() => {
    switch (user?.role) {
      case 'manager':
        return 'Managers keep their own profile up to date while reviewing their team.'
      case 'admin':
        return 'Admins retain the employee experience alongside platform controls.'
      default:
        return 'Track and grow your skills to unlock new opportunities.'
    }
  }, [user?.role])

  const personalInsights = useMemo(() => {
    const summary = user?.skill_summary ?? {}
    const normalize = (value) => Number(value ?? 0)

    const approved = normalize(summary.approved ?? summary.Approved)
    const pending = normalize(summary.pending ?? summary.Pending)
    const canceled = normalize(summary.canceled ?? summary.Canceled)
    const totalFromSummary = normalize(summary.total)
    const fallbackTotal = approved + pending + canceled
    const total = totalFromSummary || fallbackTotal

    const readiness = total > 0 ? Math.round((approved / total) * 100) : 0
    return {
      approved,
      pending,
      canceled,
      total,
      readiness,
    }
  }, [user])

  const inventoryHealthCounters = useMemo(() => ([
    {
      label: 'Approved',
      value: personalInsights.approved,
      bubbleClass: 'border-emerald-200 bg-emerald-50 text-emerald-700',
      description: 'Skills verified by reviewers',
    },
    {
      label: 'Pending',
      value: personalInsights.pending,
      bubbleClass: 'border-amber-200 bg-amber-50 text-amber-700',
      description: 'Awaiting manager approval',
    },
    {
      label: 'Needs Attention',
      value: personalInsights.canceled,
      bubbleClass: 'border-rose-200 bg-rose-50 text-rose-700',
      description: 'Rejected or expired items',
    },
  ]), [personalInsights])

  const teamSuggestedSkills = user?.suggested_skills?.team ?? []
  const companySuggestedSkills = user?.suggested_skills?.company ?? []

  const getSkillStatusMeta = (skill) => {
    if (skill?.satisfied) {
      return {
        label: 'Satisfied',
        badgeClass: 'bg-gray-100 text-gray-500 border border-gray-200',
      }
    }

    if (skill?.already_requested) {
      return {
        label: 'Requested',
        badgeClass: 'bg-amber-100 text-amber-700 border border-amber-200',
      }
    }

    return null
  }

  const renderSuggestedList = (title, description, data, emptyMessage) => {
    const sortedData = [...data].sort((a, b) => Number(a?.satisfied ?? false) - Number(b?.satisfied ?? false))
    const fallbackEmpty = 'There are no priorities set by your manager.'
    const resolvedEmptyMessage = emptyMessage ?? fallbackEmpty

    return (
      <div className="flex h-[40rem] flex-col rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6">
        <div className="space-y-1">
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--header-color)]">Suggested Growth</p>
          <h2 className="text-2xl font-semibold text-[var(--text-color)]">{title}</h2>
          <p className="text-sm text-[var(--text-color-secondary)]">{description}</p>
        </div>
        <div className="mt-4 flex-1 overflow-hidden">
          {sortedData.length === 0 ? (
            <p className="text-sm text-[var(--text-color-secondary)]">{resolvedEmptyMessage}</p>
          ) : (
            <ul className="flex h-full flex-col gap-3 overflow-y-auto pr-2">
              {sortedData.map((skill) => {
                const meta = getSkillStatusMeta(skill)
                const key = `${title}-${skill.skill_id}`
                return (
                  <li
                    key={key}
                    className={`rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4 transition-opacity ${
                      skill?.satisfied ? 'opacity-60' : 'opacity-100'
                    }`}
                  >
                    <div className="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
                      <div>
                        <p className="text-lg font-semibold text-[var(--text-color)]">{skill.name}</p>
                        <p className="text-xs text-[var(--text-color-secondary)]">
                          {skill.type} • Priority: {skill.priority}
                        </p>
                        <DesirableNote skill={skill} className="mt-1" />
                      </div>
                      {meta && (
                        <span className={`self-start rounded-full border px-3 py-1 text-xs font-semibold ${meta.badgeClass}`}>
                          {meta.label}
                        </span>
                      )}
                    </div>
                  </li>
                )
              })}
            </ul>
          )}
        </div>
      </div>
    )
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
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--header-color)]">Employee Dashboard</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">
            Welcome back, {loading ? 'Loading...' : user?.name ?? 'team member'}
          </h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">{heroCopy}</p>
        </header>

        {!loading && (
          <section className="grid gap-4">
            <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-5">
              <h3 className="text-lg font-semibold text-[var(--text-color)] mb-4">Inventory Health</h3>
              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                {inventoryHealthCounters.map((item) => (
                  <div key={item.label} className="p-4 rounded-xl border border-[var(--border-color)] bg-[var(--background-muted)]">
                    <p className="text-sm text-[var(--text-color-secondary)]">{item.label}</p>
                    <p className={`text-2xl font-bold mt-2 inline-flex px-3 py-1 rounded-full border ${item.bubbleClass}`}>
                      {formatNumber(item.value)}
                    </p>
                    <p className="mt-2 text-xs text-[var(--text-color-secondary)]">{item.description}</p>
                  </div>
                ))}
              </div>
            </div>
          </section>
        )}

        {!loading && <EmployeeSkillsPanel ownerLabel="your" />}

        {!loading && (
          <section className="grid gap-4 lg:grid-cols-2">
            {renderSuggestedList('Team Focus', 'Priority skills for this team.', teamSuggestedSkills)}
            {renderSuggestedList('Company Focus', 'Priority skills for the company.', companySuggestedSkills, 'There are no company priorities at this time.')}
          </section>
        )}
      </main>
    </div>
  )
}
