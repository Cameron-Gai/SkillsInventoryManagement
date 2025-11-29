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
    { to: '/dashboard', label: 'Employee UI', allowedRoles: ['employee', 'manager', 'admin'] },
    { to: '/team', label: 'Manager UI', allowedRoles: ['manager', 'admin'] },
    { to: '/admin', label: 'Admin UI', allowedRoles: ['admin'] },
  ]

  return (
    <aside className="w-full max-w-xs shrink-0 border-r border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
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
                `${navBaseClasses} ${
                  isActive
                    ? 'bg-[color:var(--color-primary)]/15 text-[color:var(--color-primary)]'
                    : 'text-[var(--text-color)] hover:border-[color:var(--color-primary)] hover:text-[color:var(--color-primary)]'
                }`
              }
            >
              <span>{link.label}</span>
              <span className="text-[var(--text-color-secondary)]">→</span>
            </NavLink>
          ))}
      </div>
    </aside>
  )
}
