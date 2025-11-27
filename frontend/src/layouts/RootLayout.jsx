// RootLayout.jsx
// Wraps the entire UI with global background + dark mode support.

export default function RootLayout({ children }) {
  return (
    <div className="min-h-screen bg-[var(--background)] text-[var(--text-color)] transition-colors duration-300">
      {children}
    </div>
  );
}
