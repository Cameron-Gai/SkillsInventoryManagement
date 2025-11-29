// Login.jsx
// Development-only login screen for role-based routing.

import { useEffect, useMemo, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DarkToggle from '@/components/DarkToggle'
import {
  authenticateDevUser,
  devUsers,
  getDashboardPathForRole,
  getStoredUser,
  storeUser,
} from '@/utils/auth'

export default function Login() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  const defaultPasswordHint = useMemo(() => devUsers[0]?.password ?? '', [])

  useEffect(() => {
    const existingUser = getStoredUser()
    if (existingUser) {
      navigate(getDashboardPathForRole(existingUser.role), { replace: true })
    }
  }, [navigate])

  function handleSubmit(event) {
    event.preventDefault()
    setError('')

    const user = authenticateDevUser(email.trim(), password)

    if (!user) {
      setError('Invalid development credentials. Use one of the accounts below.')
      return
    }

    storeUser(user)
    navigate(getDashboardPathForRole(user.role), { replace: true })
  }

  function handleQuickFill(user) {
    setEmail(user.email)
    setPassword(user.password)
    setError('')
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-6 py-12 bg-[var(--background)] text-[var(--text-color)]">
      <div className="w-full max-w-4xl grid gap-6 lg:grid-cols-[1.2fr_1fr] items-start">
        <section className="rounded-xl bg-[var(--card-background)] shadow-lg border border-[var(--border-color)] p-8 space-y-6">
          <div className="flex items-center justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.2em] text-[var(--text-color-subtle)] font-semibold">
                Development Mode Login
              </p>
              <h1 className="text-3xl font-bold text-[color:var(--header-color)]">Skills Inventory</h1>
              <p className="text-sm text-[var(--text-color-secondary)] mt-1">Use the dev accounts provided to preview each dashboard.
              </p>
            </div>
          <DarkToggle />
          </div>

          <form className="space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[var(--text-color)]">Email</label>
              <input
                type="email"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                placeholder="name@skills.test"
                className="w-full rounded-lg border border-[var(--input-border)] bg-[var(--input-bg)] text-[var(--text-color)] px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
              />
            </div>

            <div className="space-y-2">
              <label className="block text-sm font-semibold text-[var(--text-color)]">Password</label>
              <input
                type="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                placeholder={defaultPasswordHint}
                className="w-full rounded-lg border border-[var(--input-border)] bg-[var(--input-bg)] text-[var(--text-color)] px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
              />
              <p className="text-xs text-[var(--text-color-subtle)]">Development accounts share the same password.</p>
            </div>

            {error && (
              <div className="rounded-lg border border-[var(--state-error)] bg-[var(--state-error)] px-4 py-3 text-sm text-[color:var(--color-primary)]">
                {error}
              </div>
            )}

            <button
              type="submit"
              className="w-full py-3 rounded-lg bg-[color:var(--color-primary)] text-white font-semibold shadow hover:bg-[color:var(--color-primary-dark)] transition"
            >
              Continue to Dashboard
            </button>
          </form>
        </section>

        <aside className="space-y-4">
          <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] shadow-lg p-6">
            <p className="text-sm font-semibold text-[var(--text-color)] mb-3">Dev-Mode Credentials</p>
            <div className="space-y-3">
              {devUsers.map((user) => (
                <button
                  key={user.email}
                  type="button"
                  onClick={() => handleQuickFill(user)}
                  className="w-full text-left rounded-lg border border-[var(--border-color)] px-4 py-3 bg-[var(--panel-background)] hover:border-[color:var(--color-primary)] transition"
                >
                  <div className="flex items-center justify-between gap-2">
                    <div>
                      <p className="font-semibold text-[var(--text-color)]">{user.name}</p>
                      <p className="text-xs text-[var(--text-color-subtle)]">{user.email}</p>
                    </div>
                    <span className="text-xs px-2 py-1 rounded-full bg-[color:var(--color-primary)] text-[color:var(--text-color-contrast)] font-semibold capitalize">
                      {user.role}
                    </span>
                  </div>
                  <p className="text-xs text-[var(--text-color-subtle)] mt-1">Password: {user.password}</p>
                </button>
              ))}
            </div>
          </div>

          <div className="rounded-xl border border-[var(--border-color)] bg-[var(--panel-background)] shadow p-4 text-sm text-[var(--text-color-secondary)]">
            <p className="font-semibold text-[var(--text-color)]">SSO Coming Soon</p>
            <p className="mt-1 text-xs text-[var(--text-color-subtle)]">This environment uses a temporary development login. The final release will connect to single sign-on.</p>
          </div>
        </aside>
      </div>
    </div>
  )
}
