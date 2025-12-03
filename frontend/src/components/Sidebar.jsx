//Sidebar.jsx
import { NavLink, useNavigate } from 'react-router-dom'
import { useEffect, useState } from 'react'
import Logout from './Logout'
import teamApi from '@/api/teamApi'

const navBaseClasses =
  'flex w-full items-center justify-between rounded-lg px-3 py-2 text-sm font-semibold transition border border-transparent'

export default function Sidebar() {
  const user = JSON.parse(localStorage.getItem('sim_user'))
  const navigate = useNavigate()
  const role = user?.role
  const personId = user?.person_id
  // Initialize from cache to avoid flicker for everyone
  const cachedKey = personId ? `sim_team_size_${personId}` : null
  const cachedSize = cachedKey ? Number(localStorage.getItem(cachedKey) || '') : NaN
  const cachedHasTeam = Number.isFinite(cachedSize) ? cachedSize > 0 : null
  const [hasTeam, setHasTeam] = useState(
    role === 'manager' || role === 'admin'
      ? (cachedHasTeam ?? true) // default true so managers/admins don't see a disappearing link unless cache says no
      : false
  )
  const [teamCheckDone, setTeamCheckDone] = useState(
    role === 'manager' || role === 'admin'
      ? (cachedHasTeam !== null) // done if we had cache; fetch handled by route guard
      : true
  )

  useEffect(() => {
    // Only managers/admins may have a team; check insights to hide link if none
    if (role === 'manager' || role === 'admin') {
      teamApi
        .getTeamInsights()
        .then((res) => {
          const size = Number(res?.data?.team_size || 0)
          if (cachedKey) {
            try { localStorage.setItem(cachedKey, String(size)) } catch {}
          }
          setHasTeam(size > 0)
        })
        .catch(() => {
          setHasTeam(false)
        })
        .finally(() => setTeamCheckDone(true))
    } else {
      setHasTeam(false)
      setTeamCheckDone(true)
    }
  }, [role])

  const links = [
    { to: '/dashboard', label: 'My Profile', allowedRoles: ['employee', 'manager', 'admin'] },
    // My Team visible only if user has direct reports
    { to: '/team', label: 'My Team', allowedRoles: ['manager', 'admin'], requireHasTeam: true },
    { to: '/admin', label: 'Administration', allowedRoles: ['admin'] },
  ]

  return (
    <aside className="w-full max-w-xs shrink-0 border-r border-[var(--border-color)] bg-[var(--panel-background)] p-6 shadow-sm">
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-sm text-[var(--text-color-secondary)]">Signed in as</p>
          <p className="text-lg font-semibold text-[var(--text-color)]">{user?.name ?? 'Unknown user'}</p>
          <p className="text-xs uppercase tracking-wide text-[var(--text-color-secondary)]">{role}</p>
        </div>
        <Logout onAfterLogout={() => navigate('/login')} />
      </div>

      <div className="mt-6 space-y-2">
        {links
          .filter((link) => !link.allowedRoles || link.allowedRoles.includes(role))
          // Avoid flicker by withholding My Team until check completes
          .filter((link) => {
            if (!link.requireHasTeam) return true
            // If user isn't a manager/admin, hide immediately
            if (!(role === 'manager' || role === 'admin')) return false
            // Only show after the team check has completed and hasTeam is true
            return teamCheckDone && hasTeam
          })
          .map((link) => (
            <NavLink
              key={link.to}
              to={link.to}
              className={({ isActive }) =>
                  `${navBaseClasses} group ${
                    isActive
                      ? 'bg-[var(--background)] text-[color:var(--color-primary)] shadow-sm'
                      : 'text-[var(--text-color)] hover:bg-[var(--background)] hover:text-[color:var(--color-primary)]'
                  }`
                }
            >
                {({ isActive }) => (
                <>
                  <div className="flex items-center">
                      <span className={`mr-3 h-6 w-1.5 rounded-r-md transition-colors ${isActive ? 'bg-[color:var(--color-primary)]' : 'bg-transparent group-hover:bg-[color:var(--color-primary)]'}`} />

                      <span className={`${isActive ? 'text-[color:var(--color-primary)]' : 'text-[var(--text-color)]'} block`}>{link.label}</span>
                  </div>

                  <span className="text-[var(--text-color-secondary)]">→</span>
                </>
              )}
            </NavLink>
          ))}
      </div>
    </aside>
  )
}
