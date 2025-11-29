export default function PendingBadge({ status }) {
  if (status !== 'pending') return null

  return (
    <span className="inline-flex items-center rounded-full bg-amber-500/15 px-2.5 py-1 text-xs font-semibold text-amber-700 dark:text-amber-200">
      Pending Approval
    </span>
  )
}
