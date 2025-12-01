import { NavLink, useNavigate } from 'react-router-dom'
import Logout from './Logout'
import { getStoredUser } from '@/utils/auth'

const navBaseClasses =
  'flex w-full items-center justify-between rounded-lg px-3 py-2 text-sm font-semibold transition border border-transparent'

export default function Sidebar() {
  const user = getStoredUser()
  const navigate = useNavigate()
  const role = user?.role

  const links = [
    { to: '/dashboard', label: 'My Profile', allowedRoles: ['employee', 'manager', 'admin'] },
    { to: '/team', label: 'My Team', allowedRoles: ['manager'] },
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
