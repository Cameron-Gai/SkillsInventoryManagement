import { useEffect, useState } from 'react'
import { Navigate } from 'react-router-dom'
import teamApi from '@/api/teamApi'
import { getDashboardPathForRole, getStoredUser } from '@/utils/auth'

export default function RequireHasTeam({ children }) {
  const [checked, setChecked] = useState(false)
  const [hasTeam, setHasTeam] = useState(true)

  useEffect(() => {
    const user = getStoredUser()
    if (!user) {
      setHasTeam(false)
      setChecked(true)
      return
    }
    const role = user.role
    if (role !== 'manager' && role !== 'admin') {
      setHasTeam(false)
      setChecked(true)
      return
    }
    teamApi
      .getTeamInsights()
      .then((res) => {
        const size = Number(res?.data?.team_size || 0)
        setHasTeam(size > 0)
      })
      .catch(() => {
        setHasTeam(false)
      })
      .finally(() => setChecked(true))
  }, [])

  if (!checked) return null

  if (!hasTeam) {
    const user = getStoredUser()
    if (typeof window !== 'undefined' && window.simShowToast) {
      window.simShowToast('No direct reports yet', 'info')
    }
    const fallback = getDashboardPathForRole(user?.role || 'employee')
    return <Navigate to={fallback} replace />
  }

  return children
}
