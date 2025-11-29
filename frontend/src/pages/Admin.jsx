// Admin.jsx
// Admin dashboard keeps employee experience visible while surfacing admin tools.

import Sidebar from '@/components/Sidebar'
// Skill inventory intentionally not shown here — use the Employee view to manage profiles
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
            Admins retain the full employee dashboard for their own profile while gaining access to platform controls and
            auditing tools.
          </p>
        </header>

        <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-[var(--text-color)]">Platform controls</h2>
          <p className="mt-2 text-[var(--text-color-secondary)]">
            Backup, restore, and audit workflows will surface here. Employee skill profiles are managed in the dedicated
            Employee view so admins can review and edit records centrally.
          </p>
        </section>
      </main>
    </div>
  )
}
