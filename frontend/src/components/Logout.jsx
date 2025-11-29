// Logout.jsx
// Reusable logout button component for authenticated pages.

import { useNavigate } from 'react-router-dom'
import { clearStoredUser } from '@/utils/auth'

export default function Logout() {
  const navigate = useNavigate()

  function handleLogout() {
    clearStoredUser()
    navigate('/login', { replace: true })
  }

  return (
    <button
      type="button"
      onClick={handleLogout}
      className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700"
    >
      Logout
    </button>
  )
}
