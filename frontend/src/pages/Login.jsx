// Login.jsx
// Login screen that authenticates against the backend.

import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DarkToggle from '@/components/DarkToggle'
import authApi from '@/api/authApi'
import {
  getDashboardPathForRole,
  getStoredUser,
  storeUser,
  storeToken,
} from '@/utils/auth'

export default function Login() {
  const navigate = useNavigate()
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    const existingUser = getStoredUser()
    if (existingUser) {
      navigate(getDashboardPathForRole(existingUser.role), { replace: true })
    }
  }, [navigate])

  async function handleSubmit(event) {
    event.preventDefault()
    setError('')
    setLoading(true)

    try {
      const response = await authApi.login(username.trim(), password)
      
      storeToken(response.data.token)
      storeUser({
        person_id: response.data.person_id,
        role: response.data.role,
        name: response.data.name,
        username: response.data.username,
      })

      navigate(getDashboardPathForRole(response.data.role), { replace: true })
    } catch (err) {
      setError(err.response?.data?.error || 'Login failed. Please check your credentials.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-6 py-12 bg-[var(--background)] text-[var(--text-color)]">
      <div className="w-full max-w-md space-y-6">
        <section className="rounded-xl bg-[var(--card-background)] shadow-lg border border-[var(--border-color)] p-8 space-y-6">
          <div className="flex items-center justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-color-subtle)] font-semibold">
                Login
              </p>
              <h1 className="text-3xl font-bold text-[color:var(--header-color)]">Skills Inventory</h1>
              <p className="text-sm text-[var(--text-color-secondary)] mt-1">Sign in to access your skill profile and team management.
              </p>
            </div>
          <DarkToggle />
          </div>

          <form className="space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[var(--text-color)]">Username</label>
              <input
                type="text"
                value={username}
                onChange={(event) => setUsername(event.target.value)}
                placeholder="Enter your username"
                className="w-full rounded-lg border border-[var(--input-border)] bg-[var(--input-bg)] text-[var(--text-color)] px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
                disabled={loading}
              />
            </div>

            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[var(--text-color)]">Password</label>
              <input
                type="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                placeholder="Enter your password"
                className="w-full rounded-lg border border-[var(--input-border)] bg-[var(--input-bg)] text-[var(--text-color)] px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
                disabled={loading}
              />
            </div>

            {error && (
              <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                {error}
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full rounded-lg bg-[color:var(--color-primary)] px-4 py-3 text-sm font-semibold text-white hover:bg-[color:var(--color-primary-dark)] disabled:opacity-50 transition"
            >
              {loading ? 'Signing in...' : 'Sign in'}
            </button>
          </form>
        </section>

        <aside className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] shadow-lg p-6">
          <p className="text-sm font-semibold text-[var(--text-color)] mb-3">About</p>
          <p className="text-sm text-[var(--text-color-secondary)]">
            Welcome to Skills Inventory Management. Sign in with your username and password to access your dashboard.
          </p>
        </aside>
      </div>
    </div>
  )
}
