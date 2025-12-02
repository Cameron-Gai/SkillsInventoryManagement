# Skills Inventory Management Frontend

Vite-powered React SPA for employees, managers, and admins to review inventory health, approve skills, manage team priorities, and monitor company-wide focus areas. The app consumes the Express API served from `backend/` and relies on JWT authentication.

## Prerequisites
- Node.js 18+ (Vite requires modern Node features)
- npm 9+ (comes with recent Node distributions)

## Getting started
1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy `.env.example` to `.env` and set `VITE_API_URL` (default `http://localhost:3000/api`).
3. Start the development server with hot reload:
   ```bash
   npm run dev
   ```
   The app runs at the URL printed in the terminal (default: `http://localhost:5173`).
4. Build for production:
   ```bash
   npm run build
   ```
5. Preview the production build locally:
   ```bash
   npm run preview
   ```
6. Lint the codebase:
   ```bash
   npm run lint
   ```

### Recommended workflow
Run the backend (`npm run dev` from `backend/`) before starting Vite so `/api` requests succeed. Log in using users that exist in the seeded PostgreSQL database.

## Project structure
- `src/main.jsx` – renders `AppRouter` and wires global providers.
- `src/routes/AppRouter.jsx` – top-level routes, including protected manager/admin sections.
- `src/routes/ProtectedRoute.jsx` – guards views that require authentication or specific roles.
- `src/pages/` – feature pages (Login, Dashboard, Profile, Team, Admin, etc.).
- `src/components/` – reusable UI widgets (Sidebar, skill cards, toggles, etc.).
- `src/api/` – Axios instances plus typed API helpers (auth, users, teams, skills).
- `src/styles/` – global theme variables and layout styles.

## Routing overview
- `/login` – authentication entry point (calls `/api/auth/login`).
- `/dashboard` – employee dashboard with inventory health, company/team focus, and personal panels.
- `/profile` – profile editing plus suggested growth list.
- `/team` – manager/admin workspace for approval queues, high-value skills, and team insights.
- `/admin` – administrative controls layered on top of the team/employee experience.
- `*` – unrecognized paths fall back to `/login`.

## Development notes
- Path alias `@` resolves to `src/` (see `vite.config.js`).
- Authentication tokens + user metadata persist via `localStorage` (see `src/utils/auth.js`).
- Tailwind-like CSS variables are defined in `src/styles/theme.css`; use them for consistent theming.
- API helpers automatically attach JWTs via `src/api/axiosInstance.js`.

