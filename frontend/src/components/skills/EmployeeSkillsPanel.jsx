import { useMemo, useState, useEffect, useCallback } from 'react'
import SkillList from './SkillList'
import SkillFormModal from './SkillFormModal'
import personSkillsApi from '@/api/personSkillsApi'
import skillsApi from '@/api/skillsApi'

const UI_STATUS_FROM_DB = {
  approved: 'active',
  requested: 'pending',
  pending: 'pending',
  canceled: 'archived',
}

const DB_STATUS_FROM_UI = {
  active: 'Approved',
  pending: 'Requested',
  archived: 'Canceled',
}

const mapDbStatusToUi = (status) => UI_STATUS_FROM_DB[status?.toLowerCase?.()] || 'pending'
const mapUiStatusToDb = (status) => DB_STATUS_FROM_UI[status?.toLowerCase?.()] || 'Requested'

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
    dbStatus: skill.status ?? mapUiStatusToDb(uiStatus),
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
  }

  const handleEdit = (skill) => {
    setEditingSkill(skill)
    setIsModalOpen(true)
  }

  const handleSave = async (updatedSkill) => {
    try {
      const payload = {
        status: mapUiStatusToDb(updatedSkill.status),
        experience_years: updatedSkill.years,
        usage_frequency: updatedSkill.frequency,
        proficiency_level: updatedSkill.level,
        notes: updatedSkill.notes,
      }

      if (updatedSkill.id) {
        await personSkillsApi.updateMySkill(updatedSkill.id, payload)
      } else {
        const skillIdentifier = updatedSkill.id || updatedSkill.skill_id
        if (!skillIdentifier) {
          throw new Error('Please select a skill from the catalog.')
        }
        await personSkillsApi.addMySkill(skillIdentifier, payload)
      }
      await refreshSkills()
      setIsModalOpen(false)
    } catch (err) {
      setError('Failed to save skill: ' + err.message)
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
