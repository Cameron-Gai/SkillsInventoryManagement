# Skills Inventory Management Frontend

A Vite-powered React SPA that will serve as the user interface for the Skills Inventory Management platform. The app currently provides placeholder routes for authentication, dashboards, and admin tooling so the navigation flow can be wired before backend APIs are available.

## Prerequisites
- Node.js 18+ (Vite requires modern Node features)
- npm 9+ (comes with recent Node distributions)

## Getting started
1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the development server with hot reload:
   ```bash
   npm run dev
   ```
   The app runs at the URL printed in the terminal (default: `http://localhost:5173`).
3. Build for production:
   ```bash
   npm run build
   ```
4. Preview the production build locally:
   ```bash
   npm run preview
   ```
5. Lint the codebase:
   ```bash
   npm run lint
   ```

## Project structure
- `src/main.jsx`: React entry point that mounts the router.
- `src/routes/AppRouter.jsx`: Declares public and protected routes using React Router.
- `src/routes/ProtectedRoute.jsx`: Simple placeholder guard that will later validate authentication and roles.
- `src/pages/*`: Placeholder views for Login, Dashboard, Profile, Team, and Admin areas.
- `src/index.css`: Vite starter styles (to be replaced with project-specific theme).

## Routing overview
- `/login`: Public entry point for authentication (placeholder for now).
- `/dashboard`, `/profile`, `/team`: Protected employee/manager areas.
- `/admin`: Admin-only placeholder guarded by the `role` prop on `ProtectedRoute`.
- `*`: Unknown routes redirect to the login page.

## Development notes
- Path alias `@` resolves to `src/` (see `vite.config.js`).
- Authentication and role checks are stubbed in `ProtectedRoute.jsx`; replace these with real logic when backend endpoints are available.

