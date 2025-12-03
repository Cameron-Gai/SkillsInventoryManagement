const STORAGE_KEY = 'sim_user'
const TOKEN_KEY = 'sim_token'

export function storeUser(user) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(user))
}

export function storeToken(token) {
  localStorage.setItem(TOKEN_KEY, token)
}

export function getStoredUser() {
  const raw = localStorage.getItem(STORAGE_KEY)
  if (!raw) return null

  try {
    return JSON.parse(raw)
  } catch (error) {
    localStorage.removeItem(STORAGE_KEY)
    return null
  }
}

export function getStoredToken() {
  return localStorage.getItem(TOKEN_KEY)
}

export function clearStoredUser() {
  localStorage.removeItem(STORAGE_KEY)
  localStorage.removeItem(TOKEN_KEY)
}

export function getDashboardPathForRole(role) {
  switch (role) {
    case 'manager':
      return '/team'
    case 'admin':
      return '/admin'
    case 'employee':
    default:
      return '/dashboard'
  }
}

