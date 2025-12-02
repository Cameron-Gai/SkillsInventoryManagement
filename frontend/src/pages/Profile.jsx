// Profile.jsx
// Employee Profile page with user info and update functionality

import { useState, useEffect } from 'react'
import Logout from '@/components/Logout'
import DesirableNote from '@/components/skills/DesirableNote'
import usersApi from '@/api/usersApi'

export default function Profile() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [success, setSuccess] = useState(null)
  const [editing, setEditing] = useState(false)
  const [formData, setFormData] = useState({ person_name: '' })

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true)
        const response = await usersApi.getProfile()
        setUser(response.data)
        setFormData({ person_name: response.data.name })
      } catch (err) {
        setError('Failed to load profile')
        console.error('Error:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchUser()
  }, [])

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    try {
      setError(null)
      setSuccess(null)
      const response = await usersApi.updateProfile(formData)
      setUser(response.data)
      setEditing(false)
      setSuccess('Profile updated successfully')
      setTimeout(() => setSuccess(null), 3000)
    } catch (err) {
      setError('Failed to update profile: ' + err.message)
    }
  }

  const suggestedSkills = Array.isArray(user?.suggested_skills)
    ? user.suggested_skills
    : user?.suggested_skills?.team ?? []

  return (
    <div className="p-10 space-y-6 bg-[var(--background)] text-[var(--text-color)] min-h-screen">
      <div className="flex items-center justify-between">
        <h1 className="text-4xl font-bold text-[var(--text-color)]">My Profile</h1>
        <Logout />
      </div>

      {error && (
        <div className="rounded-md bg-red-100 p-4 text-red-700">
          {error}
        </div>
      )}

      {success && (
        <div className="rounded-md bg-green-100 p-4 text-green-700">
          {success}
        </div>
      )}

      {loading ? (
        <p className="text-[var(--text-color-secondary)]">Loading profile...</p>
      ) : (
        <>
          <div className="max-w-2xl rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6">
            {editing ? (
              <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">
                    Name
                  </label>
                  <input
                    type="text"
                    name="person_name"
                    value={formData.person_name}
                    onChange={handleChange}
                    required
                    className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] placeholder-[var(--text-color-secondary)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                  />
                </div>

                <div className="flex gap-3">
                  <button
                    type="submit"
                    className="rounded-md bg-[var(--color-primary)] px-4 py-2 text-white font-medium hover:bg-[var(--color-primary-dark)]"
                  >
                    Save Changes
                  </button>
                  <button
                    type="button"
                    onClick={() => {
                      setEditing(false)
                      setFormData({ person_name: user.name })
                    }}
                    className="rounded-md border border-[var(--border-color)] px-4 py-2 font-medium text-[var(--text-color)] hover:bg-[var(--card-background)]"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            ) : (
              <div className="space-y-4">
                <div>
                  <p className="text-sm text-[var(--text-color-secondary)]">Name</p>
                  <p className="text-lg font-medium text-[var(--text-color)]">{user?.name}</p>
                </div>

                <div>
                  <p className="text-sm text-[var(--text-color-secondary)]">Role</p>
                  <p className="text-lg font-medium text-[var(--text-color)] capitalize">{user?.role}</p>
                </div>

                <div>
                  <p className="text-sm text-[var(--text-color-secondary)]">User ID</p>
                  <p className="text-lg font-medium text-[var(--text-color)]">{user?.person_id}</p>
                </div>

                <button
                  onClick={() => setEditing(true)}
                  className="rounded-md bg-[var(--color-primary)] px-4 py-2 text-white font-medium hover:bg-[var(--color-primary-dark)]"
                >
                  Edit Profile
                </button>
              </div>
            )}
          </div>

          <section className="max-w-3xl rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6">
            <div className="space-y-2">
              <p className="text-sm font-semibold uppercase tracking-wide text-[color:var(--color-primary)]">Suggested Growth</p>
              <h2 className="text-2xl font-semibold text-[var(--text-color)]">Skills to Explore</h2>
              <p className="text-sm text-[var(--text-color-secondary)]">
                Based on the priorities your manager set for the team.
              </p>
            </div>
            {suggestedSkills.length === 0 ? (
              <p className="mt-4 text-sm text-[var(--text-color-secondary)]">
                You are up to date on your manager's desired skills.
              </p>
            ) : (
              <ul className="mt-4 space-y-3">
                {suggestedSkills.map((skill) => (
                  <li key={skill.skill_id} className="rounded-lg border border-[var(--border-color)] bg-[var(--background-muted)] p-4">
                    <div className="flex flex-col gap-2 md:flex-row md:items-center md:justify-between">
                      <div>
                        <p className="text-lg font-semibold text-[var(--text-color)]">{skill.name}</p>
                        <p className="text-xs text-[var(--text-color-secondary)]">{skill.type} • Priority: {skill.priority}</p>
                        <DesirableNote skill={skill} className="mt-1" />
                      </div>
                      <span
                        className={`self-start rounded-full px-3 py-1 text-xs font-semibold ${
                          (skill.already_pending ?? skill.already_requested)
                            ? 'bg-yellow-100 text-yellow-700'
                            : 'bg-blue-100 text-blue-700'
                        }`}
                      >
                        {(skill.already_pending ?? skill.already_requested) ? 'Pending' : 'Not started'}
                      </span>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </section>
        </>
      )}
    </div>
  )
}
