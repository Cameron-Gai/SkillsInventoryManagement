// Login.jsx
// Placeholder login page for routing validation.
// Will later include login form and authentication logic.

import DarkToggle from "@/components/DarkToggle";

export default function Login() {
  return (
    <div className="p-10 space-y-6">

      <h1 className="text-[color:var(--color-primary)] text-4xl font-bold">
        Login Page
      </h1>

      {/* Dark mode toggle button */}
      <DarkToggle />

    </div>
  );
}

