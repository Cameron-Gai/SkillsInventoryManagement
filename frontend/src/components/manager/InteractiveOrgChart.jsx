import PropTypes from 'prop-types';

function Node({ person }) {
  return (
    <div className="border rounded-lg p-3 bg-white dark:bg-neutral-900 shadow-sm">
      <p className="text-sm font-semibold text-gray-800 dark:text-gray-100">{person.name}</p>
      <p className="text-xs text-gray-500 dark:text-gray-400">{person.title}</p>
    </div>
  );
}

Node.propTypes = {
  person: PropTypes.shape({
    name: PropTypes.string.isRequired,
    title: PropTypes.string,
  }).isRequired,
};

function Branch({ node }) {
  return (
    <div className="flex flex-col items-center">
      <Node person={node} />
      {node.children?.length ? (
        <div className="flex gap-4 mt-4 flex-wrap justify-center">
          {node.children.map((child) => (
            <div key={child.name} className="flex flex-col items-center">
              <div className="w-0.5 h-4 bg-gray-300 dark:bg-neutral-700" />
              <Branch node={child} />
            </div>
          ))}
        </div>
      ) : null}
    </div>
  );
}

Branch.propTypes = {
  node: PropTypes.shape({
    name: PropTypes.string.isRequired,
    title: PropTypes.string,
    children: PropTypes.array,
  }).isRequired,
};

export default function InteractiveOrgChart({ root }) {
  const placeholder =
    root ||
    {
      name: 'Director, Engineering',
      title: 'Alex Rivera',
      children: [
        {
          name: 'Manager, UI',
          title: 'Jordan',
          children: [
            { name: 'Lead Frontend', title: 'Sky', children: [] },
            { name: 'Senior UX', title: 'Sam', children: [] },
          ],
        },
        {
          name: 'Manager, Platform',
          title: 'Taylor',
          children: [
            { name: 'Senior API', title: 'Cameron', children: [] },
            { name: 'SRE', title: 'Rowan', children: [] },
          ],
        },
      ],
    };

  return (
    <div className="bg-gradient-to-b from-gray-50 to-white dark:from-neutral-900 dark:to-neutral-950 rounded-lg shadow p-4">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-100">Interactive Org Chart</h3>
        <span className="text-xs text-gray-500 dark:text-gray-400">Placeholder hierarchy; wire to API later.</span>
      </div>
      <div className="overflow-auto">
        <Branch node={placeholder} />
      </div>
    </div>
  );
}

InteractiveOrgChart.propTypes = {
  root: PropTypes.shape({
    name: PropTypes.string,
    title: PropTypes.string,
    children: PropTypes.array,
  }),
};
