import { useEffect, useMemo, useState } from 'react'

const EXPERIENCE_DEFAULTS = {
  level: 'Intermediate',
  years: 1,
  frequency: 'Weekly',
  notes: '',
}

const REQUEST_DEFAULTS = {
  skill_name: '',
  skill_type: 'Technology',
  justification: '',
}

export default function SkillFormModal({
  isOpen,
  initialSkill,
  availableSkills = [],
  onSave,
  onClose,
}) {
  const isEditing = Boolean(initialSkill)
  const [mode, setMode] = useState('existing')
  const [experienceForm, setExperienceForm] = useState(EXPERIENCE_DEFAULTS)
  const [requestForm, setRequestForm] = useState(REQUEST_DEFAULTS)
  const [selectedSkillId, setSelectedSkillId] = useState('')
  const [formError, setFormError] = useState('')

  const catalogSkills = useMemo(
    () =>
      (availableSkills || [])
        .map((skill) => ({
          id: skill.id ?? skill.skill_id,
          name: skill.name ?? skill.skill_name ?? '',
          type: skill.type ?? skill.skill_type ?? 'Skill',
        }))
        .filter((skill) => skill.id && skill.name)
        .sort((a, b) => a.name.localeCompare(b.name)),
    [availableSkills],
  )

  useEffect(() => {
    if (initialSkill) {
      setExperienceForm({
        level: initialSkill.level ?? 'Intermediate',
        years: initialSkill.years ?? 1,
        frequency: initialSkill.frequency ?? 'Weekly',
        notes: initialSkill.notes ?? '',
      })
      setSelectedSkillId(initialSkill.skill_id || initialSkill.id || '')
    } else {
      setMode('existing')
      setExperienceForm(EXPERIENCE_DEFAULTS)
      setRequestForm(REQUEST_DEFAULTS)
      setSelectedSkillId('')
    }
    setFormError('')
  }, [initialSkill, isOpen])

  if (!isOpen) return null

  const handleExperienceChange = (event) => {
    const { name, value } = event.target
    setExperienceForm((prev) => ({
      ...prev,
      [name]: name === 'years' ? Number(value) : value,
    }))
  }

  const handleRequestChange = (event) => {
    const { name, value } = event.target
    setRequestForm((prev) => ({ ...prev, [name]: value }))
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    setFormError('')

    const experiencePayload = {
      proficiency_level: experienceForm.level,
      experience_years: Number(experienceForm.years) || 0,
      usage_frequency: experienceForm.frequency,
      notes: experienceForm.notes,
    }

    if (isEditing) {
      onSave({
        mode: 'edit',
        id: initialSkill.id,
        ...experiencePayload,
      })
      return
    }

    if (mode === 'existing') {
      if (!selectedSkillId) {
        setFormError('Please select a skill from the catalog before saving.')
        return
      }
      onSave({
        mode: 'existing',
        skill_id: Number(selectedSkillId),
        ...experiencePayload,
      })
      return
    }

    if (!requestForm.skill_name.trim()) {
      setFormError('Please provide a name for the new skill.')
      return
    }

    if (!requestForm.justification.trim()) {
      setFormError('Please explain why this skill is needed.')
      return
    }

    onSave({
      mode: 'request',
      skill_name: requestForm.skill_name.trim(),
      skill_type: requestForm.skill_type,
      justification: requestForm.justification.trim(),
    })
  }

  const handleModeChange = (nextMode) => {
    setMode(nextMode)
    setFormError('')
  }

  const actionLabel = isEditing ? 'Update Skill' : mode === 'request' ? 'Submit Request' : 'Save Skill'

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="w-full max-w-xl rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-xl font-semibold text-[var(--text-color)]">
              {initialSkill ? 'Update Skill' : 'Add Skill'}
            </h3>
            <p className="text-sm text-[var(--text-color-secondary)]">
              Skills you add stay pending until a manager or admin approves them.
            </p>
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
          {!isEditing && (
            <div className="rounded-lg border border-[var(--border-color)] bg-[var(--background)] p-3">
              <p className="text-sm font-medium text-[var(--text-color)]">How would you like to proceed?</p>
              <div className="mt-3 grid gap-3 sm:grid-cols-2">
                <button
                  type="button"
                  onClick={() => handleModeChange('existing')}
                  className={`rounded-md border px-3 py-2 text-left text-sm font-medium transition ${
                    mode === 'existing'
                      ? 'border-[color:var(--color-primary)] text-[color:var(--color-primary)]'
                      : 'border-[var(--border-color)] text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
                  }`}
                >
                  Choose an existing catalog skill
                </button>
                <button
                  type="button"
                  onClick={() => handleModeChange('request')}
                  className={`rounded-md border px-3 py-2 text-left text-sm font-medium transition ${
                    mode === 'request'
                      ? 'border-[color:var(--color-primary)] text-[color:var(--color-primary)]'
                      : 'border-[var(--border-color)] text-[var(--text-color-secondary)] hover:text-[var(--text-color)]'
                  }`}
                >
                  Request a brand new skill
                </button>
              </div>
            </div>
          )}

          {mode === 'request' && !isEditing ? (
            <div className="space-y-4">
              <label className="text-sm font-medium text-[var(--text-color)]">
                Skill Name
                <input
                  name="skill_name"
                  value={requestForm.skill_name}
                  onChange={handleRequestChange}
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                />
              </label>

              <label className="text-sm font-medium text-[var(--text-color)]">
                Category
                <select
                  name="skill_type"
                  value={requestForm.skill_type}
                  onChange={handleRequestChange}
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                >
                  <option value="Technology">Technology</option>
                  <option value="Knowledge">Knowledge</option>
                  <option value="Experience">Experience</option>
                  <option value="Other">Other</option>
                </select>
              </label>

              <label className="block text-sm font-medium text-[var(--text-color)]">
                Why does the catalog need this skill?
                <textarea
                  name="justification"
                  value={requestForm.justification}
                  onChange={handleRequestChange}
                  rows="4"
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                />
              </label>
            </div>
          ) : (
            <div className="space-y-4">
              {!isEditing && (
                <label className="text-sm font-medium text-[var(--text-color)]">
                  Choose a skill from the catalog
                  <select
                    value={selectedSkillId}
                    onChange={(event) => setSelectedSkillId(event.target.value)}
                    className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                  >
                    <option value="">Select a skill</option>
                    {catalogSkills.map((skill) => (
                      <option key={skill.id} value={skill.id}>
                        {skill.name} • {skill.type}
                      </option>
                    ))}
                  </select>
                </label>
              )}

              <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <label className="text-sm font-medium text-[var(--text-color)]">
                  Proficiency
                  <select
                    name="level"
                    value={experienceForm.level}
                    onChange={handleExperienceChange}
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
                    value={experienceForm.years}
                    onChange={handleExperienceChange}
                    className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                  />
                </label>
              </div>

              <label className="text-sm font-medium text-[var(--text-color)]">
                How often do you use it?
                <select
                  name="frequency"
                  value={experienceForm.frequency}
                  onChange={handleExperienceChange}
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                >
                  <option>Daily</option>
                  <option>Weekly</option>
                  <option>Monthly</option>
                  <option>Occasionally</option>
                </select>
              </label>

              <label className="block text-sm font-medium text-[var(--text-color)]">
                Notes
                <textarea
                  name="notes"
                  value={experienceForm.notes}
                  onChange={handleExperienceChange}
                  rows="3"
                  className="mt-1 w-full rounded-md border border-[var(--border-color)] bg-[var(--background)] px-3 py-2 text-[var(--text-color)] focus:border-[color:var(--color-primary)] focus:outline-none"
                />
              </label>
            </div>
          )}

          {formError && <p className="text-sm text-red-500">{formError}</p>}

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
              {actionLabel}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
