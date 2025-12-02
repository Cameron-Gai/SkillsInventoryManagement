import { useMemo, useState, useEffect, useCallback } from 'react'
import SkillList from './SkillList'
import SkillFormModal from './SkillFormModal'
import personSkillsApi from '@/api/personSkillsApi'
import skillsApi from '@/api/skillsApi'
import skillRequestsApi from '@/api/skillRequestsApi'

const UI_STATUS_FROM_DB = {
  approved: 'active',
  requested: 'pending',
  pending: 'pending',
  canceled: 'archived',
}

const mapDbStatusToUi = (status) => UI_STATUS_FROM_DB[status?.toLowerCase?.()] || 'pending'

function decorateSkill(skill) {
  const uiStatus = mapDbStatusToUi(skill.status)
  return {
    ...skill,
    name: skill.name ?? skill.skill_name,
    category: skill.category ?? skill.type ?? 'Core Skill',
    level: skill.proficiency_level ?? skill.level ?? 'Intermediate',
    years: skill.experience_years ?? skill.years ?? 0,
    frequency: skill.usage_frequency ?? skill.frequency ?? 'Occasionally',
    status: uiStatus,
    dbStatus: skill.status,
    notes: skill.notes ?? '',
  }
}

export default function EmployeeSkillsPanel({ ownerLabel = 'your', userId = null }) {
  const [skills, setSkills] = useState([])
  const [allSkills, setAllSkills] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [editingSkill, setEditingSkill] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [successMessage, setSuccessMessage] = useState(null)

  const refreshSkills = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)

      const userSkillsResponse = userId
        ? await personSkillsApi.getUserSkills(userId)
        : await personSkillsApi.getMySkills()

      const allSkillsResponse = await skillsApi.getAllSkills()

      const decorated = (userSkillsResponse.data || []).map(decorateSkill)
      setSkills(decorated)
      setAllSkills(allSkillsResponse.data || [])
    } catch (err) {
      setError(err.message || 'Failed to load skills')
      console.error('Error fetching skills:', err)
    } finally {
      setLoading(false)
    }
  }, [userId])

  // Fetch user's skills and available skills
  useEffect(() => {
    refreshSkills()
  }, [refreshSkills])

  const sortedSkills = useMemo(
    () => [...skills].sort((a, b) => a.name.localeCompare(b.name)),
    [skills],
  )

  const openNewSkill = () => {
    setEditingSkill(null)
    setIsModalOpen(true)
    setError(null)
  }

  const handleEdit = (skill) => {
    setEditingSkill(skill)
    setIsModalOpen(true)
    setError(null)
  }

  const handleSave = async (updatedSkill) => {
    try {
      setError(null)

      if (updatedSkill.mode === 'request') {
        await skillRequestsApi.createRequest({
          skill_name: updatedSkill.skill_name,
          skill_type: updatedSkill.skill_type,
          justification: updatedSkill.justification,
        })
        setSuccessMessage('Thanks! Your new skill request was submitted for admin review.')
      } else {
        const payload = {
          experience_years: updatedSkill.experience_years,
          usage_frequency: updatedSkill.usage_frequency,
          proficiency_level: updatedSkill.proficiency_level,
          notes: updatedSkill.notes,
        }

        if (updatedSkill.id) {
          await personSkillsApi.updateMySkill(updatedSkill.id, payload)
          setSuccessMessage('Skill details updated successfully.')
        } else {
          await personSkillsApi.addMySkill(updatedSkill.skill_id, payload)
          setSuccessMessage('Skill submitted for approval.')
        }
        await refreshSkills()
      }

      setIsModalOpen(false)
    } catch (err) {
      console.error('Error saving skill:', err)
      const message = err.response?.data?.error || err.message
      setError('Failed to save skill: ' + message)
      console.error('Error saving skill:', err)
    }
  }

  return (
    <section className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-6 shadow-sm">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h3 className="text-2xl font-semibold text-[var(--text-color)]">Skill Inventory</h3>
          <p className="text-sm text-[var(--text-color-secondary)]">Manage {ownerLabel} skill profile and keep it current.</p>
        </div>
        <button
          type="button"
          onClick={openNewSkill}
          disabled={loading}
          className="rounded-md bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[color:var(--color-primary-dark)] disabled:opacity-50"
        >
          Add Skill
        </button>
      </div>

      {error && (
        <div className="mt-4 rounded-md bg-red-100 p-3 text-red-700">
          {error}
        </div>
      )}

      {successMessage && (
        <div className="mt-4 rounded-md bg-green-100 p-3 text-green-700">
          {successMessage}
        </div>
      )}

      {loading ? (
        <div className="mt-5 text-center py-8 text-[var(--text-color-secondary)]">
          Loading skills...
        </div>
      ) : (
        <div className="mt-5">
          <SkillList skills={sortedSkills} onEdit={handleEdit} />
        </div>
      )}

      <SkillFormModal
        isOpen={isModalOpen}
        initialSkill={editingSkill}
        availableSkills={allSkills}
        onSave={handleSave}
        onClose={() => setIsModalOpen(false)}
      />
    </section>
  )
}
