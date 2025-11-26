// ProtectedRoute.jsx
// This wrapper protects routes that require authentication.
// Later, it will check:
//  - If the user is logged in
//  - If the user has the correct role (employee/manager/admin)

import { Navigate } from 'react-router-dom'

// TODO: replace with real auth logic
const isAuthenticated = true
const userRole = 'employee'

export default function ProtectedRoute({ children, role }) {
  // If not logged in, send them to the login page
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />
  }

  // If a role is required but user does not match, redirect
  if (role && role !== userRole) {
    return <Navigate to="/dashboard" replace />
  }

  // User is allowed → render the page
  return children
}
