import SkillCard from './SkillCard'

export default function SkillList({ skills, onEdit }) {
  if (!skills.length) {
    return (
      <div className="rounded-lg border border-dashed border-[var(--border-color)] bg-[var(--card-background)] p-6 text-center text-[var(--text-color-secondary)]">
        No skills added yet. Use "Add Skill" to start your inventory.
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
      {skills.map((skill) => (
        <SkillCard key={skill.id} skill={skill} onEdit={onEdit} />
      ))}
    </div>
  )
}
