import PropTypes from 'prop-types';

function Node({ person }) {
  return (
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-3 shadow-sm">
      <p className="text-sm font-semibold text-[var(--text-color)]">{person.name}</p>
      <p className="text-xs text-[var(--text-color-secondary)]">{person.title}</p>
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
              <div className="w-0.5 h-4 bg-[var(--border-color)]" />
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
    <div className="rounded-xl border border-[var(--border-color)] bg-[var(--card-background)] p-4 shadow-sm">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-lg font-semibold text-[var(--text-color)]">Interactive Org Chart</h3>
        <span className="text-xs text-[var(--text-color-secondary)]">Placeholder hierarchy; wire to API later.</span>
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
