// Login.jsx
// Placeholder login page for routing validation.
// Will later include login form and authentication logic.

import DarkToggle from "@/components/DarkToggle";
import authApi from "@/api/authApi";

async function testApi() {
  try {
    const res = await authApi.verify();
    console.log("API WORKING:", res.data);
  } catch (err) {
    console.error("ERROR:", err);
  }
}

export default function Login() {
  return (
    <div className="p-10 space-y-6">

      <h1 className="text-[color:var(--color-primary)] text-4xl font-bold">
        Login Page
      </h1>

      {/* Dark mode toggle button */}
      <DarkToggle />

	<button
	  onClick={testApi}
	  className="p-2 bg-[var(--color-primary)] text-white rounded"
	>
	  Test API
	</button>


    </div>
  );
}

