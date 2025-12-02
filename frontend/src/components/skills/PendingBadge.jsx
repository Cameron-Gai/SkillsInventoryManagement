export default function PendingBadge({ status }) {
  if (!status) return null
  const normalized = status.toLowerCase()
  if (normalized !== 'pending' && normalized !== 'requested') return null

  return (
    <span className="inline-flex items-center rounded-full bg-amber-600/25 px-2.5 py-1 text-xs font-semibold text-[var(--text-color)]">
      Pending Approval
    </span>
  )
}
