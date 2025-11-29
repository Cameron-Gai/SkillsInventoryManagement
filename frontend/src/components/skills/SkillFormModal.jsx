import { useEffect, useState } from 'react'

const DEFAULT_FORM = {
  name: '',
  category: 'Core Skill',
  level: 'Intermediate',
  years: 1,
  frequency: 'Weekly',
  status: 'active',
  notes: '',
}

export default function SkillFormModal({ isOpen, initialSkill, onSave, onClose }) {
  const [form, setForm] = useState(DEFAULT_FORM)

  useEffect(() => {
    if (initialSkill) {
      setForm(initialSkill)
    } else {
      setForm(DEFAULT_FORM)
    }
  }, [initialSkill])

  if (!isOpen) return null

  const handleChange = (event) => {
    const { name, value } = event.target
    setForm((prev) => ({ ...prev, [name]: name === 'years' ? Number(value) : value }))
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    onSave({ ...form })
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
            <label className="text-sm font-medium text-[var(--text-color)]">
              Skill Name
              <input
                required
                name="name"
                value={form.name}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              />
            </label>

            <label className="text-sm font-medium text-[var(--text-color)]">
              Category
              <select
                name="category"
                value={form.category}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              >
                <option>Core Skill</option>
                <option>Leadership</option>
                <option>Framework</option>
                <option>Tooling</option>
              </select>
            </label>

            <label className="text-sm font-medium text-[var(--text-color)]">
              Proficiency
              <select
                name="level"
                value={form.level}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              >
                <option>Beginner</option>
                <option>Intermediate</option>
                <option>Advanced</option>
                <option>Expert</option>
              </select>
            </label>

            <label className="text-sm font-medium text-[var(--text-color)]">
              Years Experience
              <input
                type="number"
                name="years"
                min="0"
                value={form.years}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              />
            </label>
          </div>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <label className="text-sm font-medium text-[var(--text-color)]">
              How often do you use it?
              <select
                name="frequency"
                value={form.frequency}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              >
                <option>Daily</option>
                <option>Weekly</option>
                <option>Monthly</option>
                <option>Occasionally</option>
              </select>
            </label>

            <label className="text-sm font-medium text-[var(--text-color)]">
              Status
              <select
                name="status"
                value={form.status}
                onChange={handleChange}
                className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
              >
                <option value="active">Active</option>
                <option value="pending">Pending</option>
                <option value="archived">Archived</option>
              </select>
            </label>
          </div>

          <label className="block text-sm font-medium text-[var(--text-color)]">
            Notes
            <textarea
              name="notes"
              value={form.notes}
              onChange={handleChange}
              rows="3"
              className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
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
            <button
              type="submit"
              className="rounded-md bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[color:var(--color-primary-dark)]"
            >
              Save Skill
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
