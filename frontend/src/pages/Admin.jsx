// Admin.jsx
// Placeholder page for Admin-only tools such as
// backup/restore, logs, and audit screens.

import Logout from '@/components/Logout'

export default function Admin() {
  return (
    <div className="p-10 space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-bold">Admin Panel</h1>
        <Logout />
      </div>
      <p>Administrative tools will be implemented here.</p>
    </div>
  )
}
