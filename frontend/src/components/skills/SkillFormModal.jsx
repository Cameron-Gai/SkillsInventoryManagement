import { useEffect, useState } from 'react'
import { createCatalogRequest } from '@/api/catalogRequestsApi'
import skillsApi from '@/api/skillsApi'
import { getStoredUser } from '@/utils/auth'

const DEFAULT_FORM = {
  skill_id: '',
  level: 'Intermediate',
  years: 1,
  frequency: 'Weekly',
  notes: '',
}

export default function SkillFormModal({ isOpen, initialSkill, availableSkills = [], onSave, onClose, onCatalogRequested, onDelete }) {
  const [form, setForm] = useState(DEFAULT_FORM)
  const isEditing = Boolean(initialSkill)
  const [showCatalogRequest, setShowCatalogRequest] = useState(false)
  const [catalogForm, setCatalogForm] = useState({ skill_name: '', skill_type: 'Technology', justification: '' })
  const [error, setError] = useState(null)
  const [success, setSuccess] = useState(null)
  const [filteredSkills, setFilteredSkills] = useState(availableSkills)

  useEffect(() => {
    if (initialSkill) {
      setForm({
        skill_id: initialSkill.id,
        level: initialSkill.level || 'Intermediate',
        years: initialSkill.years || 1,
        frequency: initialSkill.frequency || 'Weekly',
        notes: initialSkill.notes || '',
      })
    } else {
      setForm(DEFAULT_FORM)
    }
  }, [initialSkill])

  // Fetch available (not-yet-owned) skills when opening for add
  useEffect(() => {
    const run = async () => {
      try {
        setError(null)
        const user = getStoredUser()
        if (!user?.person_id) {
          setFilteredSkills(availableSkills)
          return
        }
        const resp = await skillsApi.getAvailableSkills(user.person_id)
        // Normalize to {id,name,type} for dropdown
        const normalized = resp.data
          ? resp.data.map(s => ({ id: s.skill_id || s.id, name: s.skill_name || s.name, type: s.skill_type || s.type }))
          : []
        setFilteredSkills(normalized)
      } catch (e) {
        // fallback to provided list if API fails
        setFilteredSkills(availableSkills)
      }
    }
    if (isOpen && !isEditing) {
      run()
    }
  }, [isOpen, isEditing, availableSkills])

  if (!isOpen) return null

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((prev) => ({ ...prev, [name]: name === 'years' ? Number(value) : value }))
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    onSave({ ...form })
  }

  const submitCatalogRequest = async (e) => {
    e.preventDefault()
    try {
      setError(null)
      setSuccess(null)
      if (!catalogForm.skill_name.trim()) {
        if (typeof window !== 'undefined' && typeof window.simShowToast === 'function') {
          window.simShowToast('Skill name is required', { variant: 'error' })
        } else {
          setError('Skill name is required')
        }
        return
      }
      await createCatalogRequest({
        skill_name: catalogForm.skill_name.trim(),
        skill_type: catalogForm.skill_type,
        justification: catalogForm.justification.trim(),
      })
      setShowCatalogRequest(false)
      setCatalogForm({ skill_name: '', skill_type: 'Technology', justification: '' })
      if (typeof window !== 'undefined' && typeof window.simShowToast === 'function') {
        window.simShowToast('Catalog request submitted', { variant: 'success' })
      } else {
        setSuccess('Catalog request submitted')
        setTimeout(() => setSuccess(null), 3000)
      }
      onClose?.()
      onCatalogRequested?.()
    } catch (err) {
      const msg = err.response?.data?.error || 'Failed to submit catalog request'
      if (typeof window !== 'undefined' && typeof window.simShowToast === 'function') {
        window.simShowToast(msg, { variant: 'error' })
      } else {
        setError(msg)
      }
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="w-full max-w-xl rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-xl font-semibold text-[var(--text-color)]">
              {initialSkill ? 'Update Skill' : 'Add Skill'}
            </h3>
            <p className="text-sm text-[var(--text-color-secondary)]">Keep your skill inventory current.</p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="rounded-md px-3 py-1.5 text-sm font-medium text-[var(--text-color-secondary)] hover:text-[color:var(--color-primary)]"
          >
            Close
          </button>
        </div>

        <form onSubmit={handleSubmit} className="mt-4 space-y-4">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <label className="col-span-2 text-sm font-medium text-[var(--text-color)]">
              Select Skill
              {isEditing ? (
                <div className="mt-1 w-full rounded-md border border-dashed border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)]">
                  {initialSkill?.name} ({initialSkill?.type})
                  <input type="hidden" name="skill_id" value={form.skill_id} />
                </div>
              ) : (
                <div className="mt-1 flex items-center gap-2">
                  <select
                    required
                    name="skill_id"
                    value={form.skill_id}
                    onChange={handleChange}
                    className="flex-1 rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                  >
                    <option value="">-- Choose a skill --</option>
                    {filteredSkills.map(skill => (
                      <option key={skill.id} value={skill.id}>
                        {skill.name} ({skill.type})
                      </option>
                    ))}
                  </select>
                  <button
                    type="button"
                    onClick={() => setShowCatalogRequest(true)}
                    className="whitespace-nowrap rounded-md border border-[var(--border-color)] px-3 py-2 text-sm font-medium text-[var(--text-color)] hover:bg-[var(--card-background)]"
                  >
                    Request Catalog Skill
                  </button>
                </div>
              )}
            </label>
            {!form.skill_id && (
              <p className="col-span-2 text-xs text-[var(--text-color-secondary)]">Tip: If the skill isn’t listed, use “Request Catalog Skill” to add it to the catalog for review. You can return later to add it once approved.</p>
            )}

            <label className={`text-sm font-medium ${!form.skill_id ? 'text-[var(--text-color-secondary)]' : 'text-[var(--text-color)]'}`}>
              Proficiency
              <select
                name="level"
                value={form.level}
                onChange={handleChange}
                disabled={!form.skill_id}
                className={`mt-1 w-full rounded-md border px-3 py-2 focus:outline-none ${!form.skill_id ? 'border-[var(--border-color)] bg-[var(--background-muted)] text-[var(--text-color-secondary)]' : 'border-[var(--border-color)] bg-[var(--background)] text-[var(--text-color)] focus:border-[color:var(--color-primary)]'}`}
              >
                <option>Beginner</option>
                <option>Intermediate</option>
                <option>Advanced</option>
                <option>Expert</option>
              </select>
            </label>

            <label className={`text-sm font-medium ${!form.skill_id ? 'text-[var(--text-color-secondary)]' : 'text-[var(--text-color)]'}`}>
              Years Experience
              <input
                type="number"
                name="years"
                min="0"
                value={form.years}
                onChange={handleChange}
                disabled={!form.skill_id}
                className={`mt-1 w-full rounded-md border px-3 py-2 focus:outline-none ${!form.skill_id ? 'border-[var(--border-color)] bg-[var(--background-muted)] text-[var(--text-color-secondary)]' : 'border-[var(--border-color)] bg-[var(--background)] text-[var(--text-color)] focus:border-[color:var(--color-primary)]'}`}
              />
            </label>
          </div>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <label className={`text-sm font-medium ${!form.skill_id ? 'text-[var(--text-color-secondary)]' : 'text-[var(--text-color)]'}`}>
              How often do you use it?
              <select
                name="frequency"
                value={form.frequency}
                onChange={handleChange}
                disabled={!form.skill_id}
                className={`mt-1 w-full rounded-md border px-3 py-2 focus:outline-none ${!form.skill_id ? 'border-[var(--border-color)] bg-[var(--background-muted)] text-[var(--text-color-secondary)]' : 'border-[var(--border-color)] bg-[var(--background)] text-[var(--text-color)] focus:border-[color:var(--color-primary)]'}`}
              >
                <option>Daily</option>
                <option>Weekly</option>
                <option>Monthly</option>
                <option>Occasionally</option>
              </select>
            </label>
          </div>

          <label className={`block text-sm font-medium ${!form.skill_id ? 'text-[var(--text-color-secondary)]' : 'text-[var(--text-color)]'}`}>
            Notes
            <textarea
              name="notes"
              value={form.notes}
              onChange={handleChange}
              rows="3"
              disabled={!form.skill_id}
              className={`mt-1 w-full rounded-md border px-3 py-2 focus:outline-none ${!form.skill_id ? 'border-[var(--border-color)] bg-[var(--background-muted)] text-[var(--text-color-secondary)]' : 'border-[var(--border-color)] bg-[var(--background)] text-[var(--text-color)] focus:border-[color:var(--color-primary)]'}`}
            />
          </label>

          <div className="flex justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={onClose}
              className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]"
            >
              Cancel
            </button>
            {isEditing && (
              <button
                type="button"
                onClick={() => {
                  try {
                    if (onDelete) onDelete(initialSkill.id)
                  } finally {
                    onClose?.()
                  }
                }}
                className="rounded-md border border-red-300 px-4 py-2 text-sm font-medium text-red-600 transition hover:bg-red-50 hover:border-red-500"
              >
                Delete
              </button>
            )}
            <button
              type="submit"
              disabled={!form.skill_id}
              className={`rounded-md px-4 py-2 text-sm font-semibold text-white transition ${!form.skill_id ? 'bg-gray-400 cursor-not-allowed' : 'bg-[color:var(--color-primary)] hover:bg-[color:var(--color-primary-dark)]'}`}
            >
              Save Skill
            </button>
          </div>
        </form>

        {showCatalogRequest && (
          <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4">
            <div className="w-full max-w-lg rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
              <div className="flex items-center justify-between">
                <h4 className="text-lg font-semibold text-[var(--text-color)]">Request New Catalog Skill</h4>
                <button type="button" onClick={() => setShowCatalogRequest(false)} className="rounded-md px-3 py-1.5 text-sm font-medium text-[var(--text-color-secondary)] hover:text-[color:var(--color-primary)]">Close</button>
              </div>
              {error && <div className="mt-3 rounded-md bg-red-100 p-3 text-red-700 text-sm">{error}</div>}
              {success && <div className="mt-3 rounded-md bg-green-100 p-3 text-green-700 text-sm">{success}</div>}
              <form className="mt-4 space-y-4" onSubmit={submitCatalogRequest}>
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">Skill Name</label>
                  <input
                    type="text"
                    value={catalogForm.skill_name}
                    onChange={(e) => setCatalogForm(prev => ({ ...prev, skill_name: e.target.value }))}
                    required
                    className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                    placeholder="e.g., Kubernetes, Market Analysis"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">Skill Type</label>
                  <select
                    value={catalogForm.skill_type}
                    onChange={(e) => setCatalogForm(prev => ({ ...prev, skill_type: e.target.value }))}
                    className="mt-1 block w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                  >
                    <option>Technology</option>
                    <option>Knowledge</option>
                    <option>Experience</option>
                    <option>Other</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-[var(--text-color)]">Justification (optional)</label>
                  <textarea
                    rows="3"
                    value={catalogForm.justification}
                    onChange={(e) => setCatalogForm(prev => ({ ...prev, justification: e.target.value }))}
                    className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)]"
                    placeholder="Why should this be in the catalog?"
                  />
                </div>
                <div className="flex justify-end gap-3 pt-2">
                  <button type="button" onClick={() => setShowCatalogRequest(false)} className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]">Cancel</button>
                  <button type="submit" className="rounded-md bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[color:var(--color-primary-dark)]">Submit Request</button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
