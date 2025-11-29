// Profile.jsx
// Placeholder Employee Profile page.

import Logout from '@/components/Logout'

export default function Profile() {
  return (
    <div className="p-10 space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-bold">My Profile</h1>
        <Logout />
      </div>
      <p>Profile details will go here.</p>
    </div>
  )
}
