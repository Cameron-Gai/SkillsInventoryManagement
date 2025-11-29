// Profile.jsx
// Placeholder Employee Profile page.

import Logout from '@/components/Logout'

export default function Profile() {
  return (
    <div className="p-10 space-y-6 bg-[var(--background)] text-[var(--text-color)] min-h-screen">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-bold text-[var(--text-color)]">My Profile</h1>
        <Logout />
      </div>
      <p className="text-[var(--text-color-secondary)]">Profile details will go here.</p>
    </div>
  )
}
