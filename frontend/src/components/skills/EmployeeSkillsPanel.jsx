import { useMemo, useState, useEffect } from 'react'
import SkillList from './SkillList'
import SkillFormModal from './SkillFormModal'
import personSkillsApi from '@/api/personSkillsApi'
import skillsApi from '@/api/skillsApi'

export default function EmployeeSkillsPanel({ ownerLabel = 'your', userId = null }) {
  const [skills, setSkills] = useState([])
  const [allSkills, setAllSkills] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [editingSkill, setEditingSkill] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  // Fetch user's skills and available skills
  useEffect(() => {
    const fetchSkills = async () => {
      try {
        setLoading(true)
        setError(null)

        // Fetch user's skills
        let userSkillsResponse
        if (userId) {
          userSkillsResponse = await personSkillsApi.getUserSkills(userId)
        } else {
          userSkillsResponse = await personSkillsApi.getMySkills()
        }

        // Fetch all available skills
        const allSkillsResponse = await skillsApi.getAllSkills()

        setSkills(userSkillsResponse.data || [])
        setAllSkills(allSkillsResponse.data || [])
      } catch (err) {
        setError(err.message || 'Failed to load skills')
        console.error('Error fetching skills:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchSkills()
  }, [userId])

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
      if (updatedSkill.id) {
        // Update existing skill
        await personSkillsApi.updateMySkillStatus(updatedSkill.id, updatedSkill.status)
        setSkills((prev) =>
          prev.map((skill) => (skill.id === updatedSkill.id ? updatedSkill : skill))
        )
      } else {
        // Add new skill
        await personSkillsApi.addMySkill(updatedSkill.id || updatedSkill.skill_id)
        setSkills((prev) => [...prev, updatedSkill])
      }
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
