// Logout.jsx
// Reusable logout button component for authenticated pages.

import { useNavigate } from 'react-router-dom'
import { clearStoredUser } from '@/utils/auth'

export default function Logout({ onAfterLogout }) {
  const navigate = useNavigate()

  function handleLogout() {
    clearStoredUser()
    onAfterLogout?.()
    navigate('/login', { replace: true })
  }

  return (
    <button
      type="button"
      onClick={handleLogout}
      className="rounded-md border border-[var(--border-color)] px-3 py-1.5 text-sm font-medium text-[var(--text-color)] transition hover:border-[color:var(--color-primary)] hover:text-[color:var(--color-primary)]"
    >
      Logout
    </button>
  )
}
