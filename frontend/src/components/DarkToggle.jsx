export default function DarkToggle() {
  function toggle() {
    const isDark = document.documentElement.classList.toggle('dark')
    // When switching modes, update the primary accent variable so
    // dark mode can use the older/brighter red while light mode uses
    // the accessible light-theme red.
    try {
      const DARK_PRIMARY = '#E4002B' // older/brighter red for dark mode
      const LIGHT_PRIMARY = '#B00020' // accessible red for light mode
      document.documentElement.style.setProperty('--color-primary', isDark ? DARK_PRIMARY : LIGHT_PRIMARY)
      // update derived darker variant used for hover
      const DARK_PRIMARY_DARK = '#C00021'
      const LIGHT_PRIMARY_DARK = '#8A0018'
      document.documentElement.style.setProperty('--color-primary-dark', isDark ? DARK_PRIMARY_DARK : LIGHT_PRIMARY_DARK)

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
      🌙
    </button>
  );
}
