import { useMemo, useState, useEffect } from 'react'
import SkillList from './SkillList'
import SkillFormModal from './SkillFormModal'
import { useToast } from '@/components/ToastProvider'
import personSkillsApi from '@/api/personSkillsApi'
import skillsApi from '@/api/skillsApi'

export default function EmployeeSkillsPanel({ ownerLabel = 'your', userId = null }) {
  const [skills, setSkills] = useState([])
  const [allSkills, setAllSkills] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [editingSkill, setEditingSkill] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const { showToast } = useToast()

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

  const handleSave = async (skillData) => {
    try {
      if (editingSkill) {
        // Update existing skill
        const response = await personSkillsApi.addMySkill(skillData)
        setSkills((prev) => prev.map(s => s.id === skillData.skill_id ? response.data : s))
      } else {
        // Add new skill request
        const response = await personSkillsApi.addMySkill(skillData)
        setSkills((prev) => [...prev, response.data])
      }
      setIsModalOpen(false)
      setEditingSkill(null)
      showToast('Skill saved', { variant: 'success' })
    } catch (err) {
      const msg = err.response?.data?.error || 'Failed to save skill'
      showToast(msg, { variant: 'error' })
      console.error('Error saving skill:', err)
    }
  }

  const handleCatalogRequested = () => {
    showToast('Catalog request submitted', { variant: 'success' })
  }

  const [deleteConfirm, setDeleteConfirm] = useState(null)

  const handleDelete = async (skillId) => {
    setDeleteConfirm(skillId)
  }

  const confirmDelete = async () => {
    try {
      await personSkillsApi.removeMySkill(deleteConfirm)
      setSkills((prev) => prev.filter(s => s.id !== deleteConfirm))
      setDeleteConfirm(null)
    } catch (err) {
      setError('Failed to delete skill: ' + err.message)
      console.error('Error deleting skill:', err)
      setDeleteConfirm(null)
    }
  }

  const cancelDelete = () => {
    setDeleteConfirm(null)
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
          <SkillList skills={sortedSkills} onEdit={handleEdit} onDelete={handleDelete} />
        </div>
      )}

      <SkillFormModal
        isOpen={isModalOpen}
        initialSkill={editingSkill}
        availableSkills={allSkills}
        onSave={handleSave}
        onClose={() => setIsModalOpen(false)}
        onCatalogRequested={handleCatalogRequested}
        onDelete={(id) => setDeleteConfirm(id)}
      />
      {/* Toasts handled globally by ToastProvider */}

      {/* Delete Confirmation Modal */}
      {deleteConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="w-full max-w-md rounded-lg bg-[var(--card-background)] p-6 shadow-xl">
            <h3 className="text-xl font-semibold text-[var(--text-color)]">Delete Skill Request</h3>
            <p className="mt-3 text-sm text-[var(--text-color-secondary)]">
              Are you sure you want to delete this skill request? This action cannot be undone.
            </p>
            <div className="mt-6 flex justify-end gap-3">
              <button
                type="button"
                onClick={cancelDelete}
                className="rounded-md border border-[var(--border-color)] px-4 py-2 text-sm font-medium text-[var(--text-color-secondary)] hover:border-[color:var(--color-primary)]"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={confirmDelete}
                className="rounded-md bg-red-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-red-700"
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  )
}
