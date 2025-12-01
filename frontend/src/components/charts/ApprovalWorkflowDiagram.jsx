import PropTypes from 'prop-types';

const defaultSteps = [
  { id: 'submit', label: 'Submit', status: 'complete' },
  { id: 'manager', label: 'Manager Review', status: 'in-progress' },
  { id: 'admin', label: 'Admin Approval', status: 'pending' },
  { id: 'done', label: 'Completed', status: 'pending' },
];

const statusStyles = {
  complete: 'bg-emerald-500',
  'in-progress': 'bg-amber-400',
  pending: 'bg-gray-300 dark:bg-neutral-700',
};

export default function ApprovalWorkflowDiagram({ steps = defaultSteps }) {
  return (
    <div className="bg-white dark:bg-neutral-900 rounded-lg shadow p-4">
      <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-4">Approval Workflow</h3>
      <div className="flex items-center justify-between gap-3">
        {steps.map((step, idx) => (
          <div key={step.id} className="flex-1 flex flex-col items-center text-center">
            <div className="flex items-center w-full">
              <div className={`h-10 w-10 rounded-full flex items-center justify-center text-white ${statusStyles[step.status]}`}>
                {idx + 1}
              </div>
              {idx < steps.length - 1 && <div className="flex-1 h-1 bg-gray-200 dark:bg-neutral-800" />}
            </div>
            <p className="text-sm font-semibold text-gray-800 dark:text-gray-100 mt-2">{step.label}</p>
            <p className="text-xs text-gray-500 dark:text-gray-400 capitalize">{step.status}</p>
          </div>
        ))}
      </div>
      <p className="text-xs text-gray-500 dark:text-gray-400 mt-3">Connect to approvals API to drive live status.</p>
    </div>
  );
}

ApprovalWorkflowDiagram.propTypes = {
  steps: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      label: PropTypes.string.isRequired,
      status: PropTypes.oneOf(['complete', 'in-progress', 'pending']).isRequired,
    }),
  ),
};
