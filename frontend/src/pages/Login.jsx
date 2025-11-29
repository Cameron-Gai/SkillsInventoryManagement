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
        <section className="rounded-xl bg-white/70 dark:bg-slate-900/50 shadow-lg border border-slate-200/60 dark:border-slate-700/60 p-8 space-y-6 backdrop-blur">
          <div className="flex items-center justify-between gap-4">
            <div>
              <p className="text-xs uppercase tracking-[0.2em] text-slate-500 dark:text-slate-400 font-semibold">
                Development Mode Login — SSO Coming Soon
              </p>
              <h1 className="text-3xl font-bold text-[color:var(--color-primary)]">Skills Inventory</h1>
              <p className="text-sm text-slate-600 dark:text-slate-300 mt-1">Use the dev accounts below to preview each dashboard.</p>
            </div>
            <DarkToggle />
          </div>

          <form className="space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-2">
              <label className="block text-sm font-semibold text-slate-700 dark:text-slate-200">Email</label>
              <input
                type="email"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                placeholder="name@skills.test"
                className="w-full rounded-lg border border-slate-200 dark:border-slate-700 bg-transparent px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
              />
            </div>

            <div className="space-y-2">
              <label className="block text-sm font-semibold text-slate-700 dark:text-slate-200">Password</label>
              <input
                type="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                placeholder={defaultPasswordHint}
                className="w-full rounded-lg border border-slate-200 dark:border-slate-700 bg-transparent px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[color:var(--color-primary)]"
                required
              />
              <p className="text-xs text-slate-500 dark:text-slate-400">Development accounts share the same password.</p>
            </div>

            {error && (
              <div className="rounded-lg border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700 dark:border-red-800 dark:bg-red-950/50 dark:text-red-200">
                {error}
              </div>
            )}

            <button
              type="submit"
              className="w-full py-3 rounded-lg bg-[color:var(--color-primary)] text-white font-semibold shadow hover:bg-[color:var(--color-primary-light)] transition"
            >
              Continue to Dashboard
            </button>
          </form>
        </section>

        <aside className="space-y-4">
          <div className="rounded-xl border border-slate-200/70 dark:border-slate-700/60 bg-white/70 dark:bg-slate-900/50 shadow-lg backdrop-blur p-6">
            <p className="text-sm font-semibold text-slate-600 dark:text-slate-200 mb-3">Dev-Mode Credentials</p>
            <div className="space-y-3">
              {devUsers.map((user) => (
                <button
                  key={user.email}
                  type="button"
                  onClick={() => handleQuickFill(user)}
                  className="w-full text-left rounded-lg border border-slate-200 dark:border-slate-700 px-4 py-3 bg-slate-50/70 dark:bg-slate-800/60 hover:border-[color:var(--color-primary)] transition"
                >
                  <div className="flex items-center justify-between gap-2">
                    <div>
                      <p className="font-semibold text-slate-800 dark:text-slate-100">{user.name}</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">{user.email}</p>
                    </div>
                    <span className="text-xs px-2 py-1 rounded-full bg-[color:var(--color-primary)]/10 text-[color:var(--color-primary)] font-semibold capitalize">
                      {user.role}
                    </span>
                  </div>
                  <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Password: {user.password}</p>
                </button>
              ))}
            </div>
          </div>

          <div className="rounded-xl border border-orange-200/70 dark:border-orange-800/60 bg-orange-50/70 dark:bg-orange-950/30 shadow p-4 text-sm text-orange-900 dark:text-orange-200">
            <p className="font-semibold">SSO Coming Soon</p>
            <p className="mt-1 text-xs">This environment uses a temporary development login. The final release will connect to single sign-on.</p>
          </div>
        </aside>
      </div>
    </div>
  )
}
