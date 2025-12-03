# Skills Inventory Management

A full-stack app for tracking employee skills, approvals, and team priorities.

Backend: Express + PostgreSQL. Frontend: React + Vite.

## Repository Structure
- `backend/` — Node/Express API, PostgreSQL connection, routes
- `frontend/` — React SPA, API clients, UI
- `scripts/` — helper SQL and utilities
- `CamDB.sql` — PostgreSQL dump used to initialize a working database
- `db_old.sql` — older dump for reference/backups

## Prerequisites
- Node.js 18+ and npm
- PostgreSQL 14+ (tested with newer versions)
- pgAdmin (optional) or `psql` CLI

## Quick Start
Follow these steps to stand up the database, backend, and frontend.

### 1) Prepare PostgreSQL using `CamDB.sql`

Option A — pgAdmin (GUI):
- Open pgAdmin → connect to your server.
- Create a database (recommended name): `skills_inventory`.
- Right-click the database → Query Tool → open and execute `CamDB.sql` from repo root.
- Verify with:
	- `SELECT COUNT(*) FROM public.person;`
	- `SELECT COUNT(*) FROM public.skill;`

Option B — `psql` (CLI) on Windows PowerShell:

```powershell
# Create database and user (adjust as needed)
psql -h localhost -U postgres -c "CREATE DATABASE skills_inventory;"
psql -h localhost -U postgres -c "CREATE ROLE skills_user WITH LOGIN PASSWORD 'changeme';"
psql -h localhost -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE skills_inventory TO skills_user;"

# Import the dump (CamDB.sql) into the database
psql -h localhost -U postgres -d skills_inventory -f "c:\Users\Camer\OneDrive\Documents\GitHub\SkillsInventoryManagement\CamDB.sql"

# Optional: make skills_user the default owner of tables
psql -h localhost -U postgres -d skills_inventory -c "ALTER SCHEMA public OWNER TO skills_user;"
```

Notes:
- The dump creates types, tables, sequences, and loads person/skill data.
- If you imported as `postgres`, you can still connect with `skills_user` if granted privileges.

### 2) Configure backend

- Copy `backend/.env.example` → `backend/.env` and edit values to match your local Postgres.
- Default values assume the database created above.

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=skills_inventory
DB_USER=skills_user
DB_PASSWORD=changeme
JWT_SECRET=supersecret_dev_key_change_me
JWT_EXPIRES_IN=24h
API_VERSION=v1
API_BASE_URL=/api
CORS_ORIGIN=http://localhost:5173
```

Install and run the backend:

```powershell
cd backend
npm install
npm run dev
# Health check
curl http://localhost:3000/health
```

### 3) Configure frontend

- Ensure the frontend points to the backend’s `/api` (the backend mounts routes at `/api`).
- Recommended: create `frontend/.env` with `VITE_API_URL=http://localhost:3000/api`.

Run the frontend:

```powershell
cd frontend
npm install
npm run dev
# open http://localhost:5173
```

### 4) Login note (hashed passwords)

`CamDB.sql` contains users with bcrypt-hashed passwords. If you need a known login:

1) Generate a bcrypt hash for a password (e.g., `admin123`):
```powershell
node -e "const bcrypt=require('bcrypt');bcrypt.hash('admin123',10).then(h=>console.log(h))"
```
2) Update a user’s password in Postgres (replace `<HASH>` and username):
```powershell
psql -h localhost -U postgres -d skills_inventory -c "UPDATE public.person SET password='<HASH>' WHERE username='mylo.hobbs';"
```

Pick a manager/admin from `public.person` (e.g., role `manager` or `is_admin=true`).

## Backend API Highlights
- `/health` — DB heartbeat
- `/api/auth/login` — JWT login (username + password)
- `/api/team/high-value-skills` — manager-admin team priorities
- `/api/team/my-team` and `/api/team/my-team/approved-skills` — team views
- `/api/person-skills/*` and `/api/skills/*` — skills management

## Troubleshooting
- Frontend 404s to `/api/v1`: set `VITE_API_URL=http://localhost:3000/api`.
- CORS errors: set `CORS_ORIGIN=http://localhost:5173` (or your dev URL).
- Duplicate inserts: many endpoints use `ON CONFLICT` to be idempotent.
