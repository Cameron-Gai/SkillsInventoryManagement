// AppRouter.jsx
// This file defines all the routes in the frontend.
// It connects URLs ("/login", "/dashboard", etc.) to React components.

import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import ProtectedRoute from './ProtectedRoute'
import { getDashboardPathForRole, getStoredUser } from '@/utils/auth'

// Pages
import Login from '@/pages/Login'
import Dashboard from '@/pages/Dashboard'
import Profile from '@/pages/Profile'
import Team from '@/pages/Team'
import Admin from '@/pages/Admin'

function HomeRedirect() {
  const user = getStoredUser()

  if (!user) {
    return <Navigate to="/login" replace />
  }

  return <Navigate to={getDashboardPathForRole(user.role)} replace />
}

export default function AppRouter() {
  return (
    <BrowserRouter>
      <Routes>
        {/* Public routes */}
        <Route path="/login" element={<Login />} />

        {/* Protected routes (require login) */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />

        <Route
          path="/profile"
          element={
            <ProtectedRoute>
              <Profile />
            </ProtectedRoute>
          }
        />

        <Route
          path="/team"
          element={
            <ProtectedRoute role="manager">
              <Team />
            </ProtectedRoute>
          }
        />

        {/* Admin-only placeholder */}
        <Route
          path="/admin"
          element={
            <ProtectedRoute role="admin">
              <Admin />
            </ProtectedRoute>
          }
        />

        {/* Default route */}
        <Route path="/" element={<HomeRedirect />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  )
}
