# Skills Inventory Backend

This package hosts the Express.js backend for the Skills Inventory and Catalog System. It provides health checks, API routing, and centralized configuration for connecting to databases and other services.

## Prerequisites
- Node.js 18+ and npm
- Docker Desktop (recommended) or access to a PostgreSQL 15 instance
- PowerShell (if you plan to run the repo bootstrap script)

## Getting Started
1. Install dependencies:
   ```bash
   npm install
   ```
2. Copy `.env.example` to `.env` and populate the values listed in [Environment variables](#environment-variables).
3. (Optional) Provision and seed the demo PostgreSQL database:
   ```powershell
   powershell -ExecutionPolicy Bypass -File ../scripts/bootstrap_sim_env.ps1
   ```
   The script launches a `postgres:15` container named `sim-postgres`, creates default credentials (`sim_user` / `SimP@ssw0rd`), imports `scripts/seed.xlsx`, randomizes employee skills, and assigns manager/team focus priorities.
4. Start the server (Hot Reload):
   ```bash
   npm run dev
   ```
   The API listens on `PORT` (default `3000`) and exposes a health check at `/health`.

### Default credentials
Running `bootstrap_sim_env.ps1` (or executing `node scripts/set_default_passwords.js` manually) hashes `DEFAULT_USER_PASSWORD` for every person record. The default value is `Password123!`, so once seeding finishes you can sign in as any username listed in the `person` table using that password unless you change the variable.

## Available Scripts
- `npm start` – start the Express server.
- `npm run dev` – start the server with nodemon style reloads.

## API Endpoints
- `GET /health` – returns a JSON payload with status, timestamp, and active environment.

## Environment Variables
Configuration defaults are defined in `src/config/config.js`. The following variables are supported:

- `PORT` (default `3000`)
- `NODE_ENV` (default `development`)
- `DB_HOST` (default `localhost`)
- `DB_PORT` (default `5432`)
- `DB_NAME` (default `skills_inventory`)
- `DB_USER`
- `DB_PASSWORD`
- `DEFAULT_USER_PASSWORD` (default `Password123!` used by `scripts/set_default_passwords.js`)
- `JWT_SECRET`
- `JWT_EXPIRES_IN` (default `24h`)
- `API_VERSION` (default `v1`)
- `API_BASE_URL` (default `/api`)
- `CORS_ORIGIN` (default `http://localhost:3000`)
- `LOG_LEVEL` (default `info`)

## Database & Seeding Utilities
- `scripts/xlsxtoDB.py` – bulk-imports `scripts/seed.xlsx` sheets into the configured database.
- `scripts/assign_random_skills.py` – populates `person_skill` with randomized statuses, proficiency metadata, and timestamps.
- `scripts/randomize_team_focus.py` – assigns `team_high_value_skills` entries for every manager that has direct reports.
- `scripts/bootstrap_sim_env.ps1` – orchestrates Docker setup plus the scripts above so you can reproduce the full demo dataset in one step.
- `scripts/set_default_passwords.js` – hashes the `DEFAULT_USER_PASSWORD` for every `person` row lacking a bcrypt hash so local logins always work.

> `bootstrap_sim_env.ps1` deletes and recreates the `sim-postgres-data` Docker volume by default (clean seed). Use the `-PreserveVolume` switch to keep existing data.

All seeders honor `backend/.env` for `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD`.

## Project Structure
- `server.js` – Express application entry point, middleware, error handling, and server bootstrap.
- `src/config/` – Environment + database config and auth helpers.
- `src/routes/` – Feature routers (auth, users, skills, teams, etc.).
- `src/utils/` – Supporting libraries (e.g., company focus calculators, hashing helpers).

## Notes
- Health check: `GET /api/health`
- Authentication: JWT via `/api/auth/login` (tokens verified by middleware in `src/config/auth`)
- When adjusting schema, update both the migration SQL (under `/database` or `/scripts`) and the Excel seed file if you rely on the bootstrapper.
