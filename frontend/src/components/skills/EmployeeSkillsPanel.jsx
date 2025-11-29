import { useMemo, useState } from 'react'
import SkillList from './SkillList'
import SkillFormModal from './SkillFormModal'

const DEFAULT_SKILLS = [
  {
    id: 1,
    name: 'React',
    category: 'Framework',
    level: 'Advanced',
    years: 4,
    frequency: 'Daily',
    status: 'active',
    notes: 'Building reusable design system components and dashboards.',
  },
  {
    id: 2,
    name: 'People Management',
    category: 'Leadership',
    level: 'Intermediate',
    years: 2,
    frequency: 'Weekly',
    status: 'pending',
    notes: 'Coaching individual contributors and running 1:1s.',
  },
  {
    id: 3,
    name: 'SQL',
    category: 'Core Skill',
    level: 'Intermediate',
    years: 5,
    frequency: 'Weekly',
    status: 'active',
    notes: 'Authoring analytics queries and data quality checks.',
  },
]

export default function EmployeeSkillsPanel({ ownerLabel = 'your' }) {
  const [skills, setSkills] = useState(DEFAULT_SKILLS)
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [editingSkill, setEditingSkill] = useState(null)

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

  const handleSave = (updatedSkill) => {
    if (updatedSkill.id) {
      setSkills((prev) => prev.map((skill) => (skill.id === updatedSkill.id ? updatedSkill : skill)))
    } else {
      const nextSkill = {
        ...updatedSkill,
        id: crypto.randomUUID(),
      }
      setSkills((prev) => [...prev, nextSkill])
    }
    setIsModalOpen(false)
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
          className="rounded-md bg-[color:var(--color-primary)] px-4 py-2 text-sm font-semibold text-white transition hover:bg-[color:var(--color-primary-dark)]"
        >
          Add Skill
        </button>
      </div>

      <div className="mt-5">
        <SkillList skills={sortedSkills} onEdit={handleEdit} />
      </div>

      <SkillFormModal
        isOpen={isModalOpen}
        initialSkill={editingSkill}
        onSave={handleSave}
        onClose={() => setIsModalOpen(false)}
      />
    </section>
  )
}
