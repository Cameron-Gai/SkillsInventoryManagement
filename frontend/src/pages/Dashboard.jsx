// Dashboard.jsx
// Placeholder Dashboard page for authenticated users.

import Logout from '@/components/Logout'

export default function Dashboard() {
  return (
    <div className="p-10 space-y-6 bg-[var(--background)] text-[var(--text-color)] min-h-screen">
      
      <div className="flex items-center justify-between">
        <h1 className="text-[color:var(--color-primary)] text-4xl font-bold">
          Welcome to the Dashboard
        </h1>

        <Logout />
      </div>

      <div className="bg-[var(--card-background)] border border-[var(--border-color)] text-[var(--text-color)] p-4 rounded-lg shadow">
        Styled with the global theme
      </div>

    </div>
  )
}
