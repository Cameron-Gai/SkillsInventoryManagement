// Team.jsx
// Manager dashboard builds on top of the employee experience.

import Sidebar from '@/components/Sidebar'
import EmployeeSkillsPanel from '@/components/skills/EmployeeSkillsPanel'
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
            Keep your own skills current while reviewing the team roster. Employee tooling remains available so managers can
            update their personal inventory without switching contexts.
          </p>
        </header>

        <EmployeeSkillsPanel ownerLabel="your" />

        <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
          <h2 className="text-xl font-semibold text-[var(--text-color)]">Team snapshot</h2>
          <p className="mt-2 text-[var(--text-color-secondary)]">
            Team insights and approvals will be built here. Managers can jump to employee records after confirming their own
            skill updates.
          </p>
        </section>
      </main>
    </div>
  )
}
