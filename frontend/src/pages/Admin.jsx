// Admin.jsx
// Admin dashboard keeps the employee experience available without duplicating UI.

import { Link } from 'react-router-dom'
import Sidebar from '@/components/Sidebar'
import { getStoredUser } from '@/utils/auth'

export default function Admin() {
  const user = getStoredUser()

  return (
    <div className="flex min-h-screen bg-[var(--background)] text-[var(--text-color)]">
      <Sidebar />

      <main className="flex-1 space-y-6 p-8">
        <header className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Admin UI</p>
          <h1 className="mt-2 text-3xl font-bold text-[var(--text-color)]">Welcome, {user?.name ?? 'Admin'}</h1>
          <p className="mt-3 max-w-3xl text-[var(--text-color-secondary)]">
            Admin tools build on top of the standard employee dashboard. Manage your own skills from the Employee Dashboard
            link in the sidebar while using this space for platform controls.
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
          <h2 className="text-xl font-semibold text-[var(--text-color)]">Platform controls</h2>
          <p className="mt-2 text-[var(--text-color-secondary)]">
            Backup, restore, and audit workflows will surface here while keeping employee utilities in their dedicated
            dashboard.
          </p>
        </section>
      </main>
    </div>
  )
}
