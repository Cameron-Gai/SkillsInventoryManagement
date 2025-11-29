export default function ThemeToggle() {
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
      className="p-2 rounded bg-[var(--color-primary)] text-white"
      aria-label="Toggle dark mode"
    >
      Toggle Dark Mode
    </button>
  );
}
