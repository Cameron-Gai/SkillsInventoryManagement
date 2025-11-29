// Admin.jsx
// Placeholder page for Admin-only tools such as
// backup/restore, logs, and audit screens.

import Logout from '@/components/Logout'

export default function Admin() {
  return (
    <div className="p-10 space-y-6 bg-[var(--background)] text-[var(--text-color)] min-h-screen">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-bold text-[var(--text-color)]">Admin Panel</h1>
        <Logout />
      </div>
      <p className="text-[var(--text-color-secondary)]">Administrative tools will be implemented here.</p>
    </div>
  )
}
