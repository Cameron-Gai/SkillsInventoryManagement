// ProtectedRoute.jsx
// This wrapper protects routes that require authentication.
// Later, it will check:
//  - If the user is logged in
//  - If the user has the correct role (employee/manager/admin)

import { Navigate } from 'react-router-dom'
import { getStoredUser, getDashboardPathForRole } from '@/utils/auth'

export default function ProtectedRoute({ children, role }) {
  const user = getStoredUser()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  if (role && role !== user.role) {
    return <Navigate to={getDashboardPathForRole(user.role)} replace />
  }

  return children
}
