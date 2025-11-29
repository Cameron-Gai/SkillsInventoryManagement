export default function ThemeToggle() {
  function toggle() {
    document.documentElement.classList.toggle("dark");
  }

  return (
    <button
      onClick={toggle}
      className="p-2 rounded bg-[var(--color-primary)] text-white"
    >
      Toggle Dark Mode
    </button>
  );
}
