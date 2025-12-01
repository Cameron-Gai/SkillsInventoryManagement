// Dashboard.jsx
// Employee Dashboard is the base experience available to all roles.

import { useMemo, useState, useEffect } from 'react'
import Sidebar from '@/components/Sidebar'
import EmployeeSkillsPanel from '@/components/skills/EmployeeSkillsPanel'
import usersApi from '@/api/usersApi'

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

        {!loading && <EmployeeSkillsPanel ownerLabel="your" />}
      </main>
    </div>
  )
}
