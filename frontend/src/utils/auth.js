const STORAGE_KEY = 'sim_user'

export const devUsers = [
  {
    email: 'employee@skills.test',
    password: 'password123',
    role: 'employee',
    name: 'Employee Erin',
  },
  {
    email: 'manager@skills.test',
    password: 'password123',
    role: 'manager',
    name: 'Manager Morgan',
  },
  {
    email: 'admin@skills.test',
    password: 'password123',
    role: 'admin',
    name: 'Admin Avery',
  },
]

export function authenticateDevUser(email, password) {
  const match = devUsers.find(
    (user) => user.email.toLowerCase() === email.toLowerCase() && user.password === password,
  )

  if (!match) return null

  const { password: _password, ...safeUser } = match
  return safeUser
}

export function storeUser(user) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(user))
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

export function clearStoredUser() {
  localStorage.removeItem(STORAGE_KEY)
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
