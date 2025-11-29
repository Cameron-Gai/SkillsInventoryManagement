// Team.jsx
// Manager dashboard builds on top of the employee experience without duplicating it.

import { Link } from 'react-router-dom'
import Sidebar from '@/components/Sidebar'
import { getStoredUser } from '@/utils/auth'

export default function Team() {
  const user = getStoredUser()

  return (
    <div className="flex min-h-screen bg-[var(--background)] text-[var(--text-color)]">
      <Sidebar />

      <main className="flex-1 space-y-6 p-8">
        <header className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Manager UI</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">Welcome, {user?.name ?? 'Manager'}</h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">
            Use this view to monitor your team and complete approvals. Your personal skill profile remains available in the
            Employee Dashboard via the sidebar.
          </p>
          <div className="mt-4">
            <Link
              to="/dashboard"
              className="inline-flex items-center rounded-lg bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white shadow hover:bg-[color:var(--color-primary-dark)]"
            >
              Go to Employee Dashboard
            </Link>
          </div>
        </header>

        <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-[var(--text-color)]">Team snapshot</h2>
          <p className="mt-2 text-[var(--text-color-secondary)]">
            Team insights and approvals will be built here, keeping the manager view focused on oversight rather than
            duplicating employee tools.
          </p>
        </section>
      </main>
    </div>
  )
}
