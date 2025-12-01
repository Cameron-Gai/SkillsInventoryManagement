// ProtectedRoute.jsx
// This wrapper protects routes that require authentication.
// Later, it will check:
//  - If the user is logged in
//  - If the user has the correct role (employee/manager/admin)

import { Navigate } from 'react-router-dom'
import { getStoredUser, getDashboardPathForRole } from '@/utils/auth'

const ROLE_LEVEL = {
  employee: 1,
  manager: 2,
  admin: 3,
}

export default function ProtectedRoute({ children, role }) {
  const user = getStoredUser()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  if (role) {
    const userLevel = ROLE_LEVEL[user.role] ?? 0
    const requiredLevel = ROLE_LEVEL[role] ?? 0

    if (userLevel < requiredLevel) {
      return <Navigate to={getDashboardPathForRole(user.role)} replace />
    }
  }

  return children
}
