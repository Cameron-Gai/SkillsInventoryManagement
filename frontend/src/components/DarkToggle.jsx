export default function DarkToggle() {
  function toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    try {
      localStorage.setItem('sim_theme', isDark ? 'dark' : 'light')
    } catch (e) {
      // ignore storage errors
    }
  }

  return (
    <button
      onClick={toggle}
      className="p-2 rounded bg-[color:var(--color-primary)] text-[color:var(--text-color-contrast)] hover:bg-[color:var(--color-primary-dark)] transition"
      aria-label="Toggle dark mode"
    >
      🌙 Theme
    </button>
  );
}
