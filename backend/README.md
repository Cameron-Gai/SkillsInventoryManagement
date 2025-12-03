# Skills Inventory Backend

Express.js API for the Skills Inventory app. Connects to PostgreSQL, exposes role-based endpoints, and serves health checks.

## Prerequisites
- Node.js 18+ and npm
- PostgreSQL 14+ (or newer)
- pgAdmin or `psql` CLI

## Database Setup with `CamDB.sql`
Use the root-level `CamDB.sql` to create a working schema with data.

Option A — pgAdmin:
- Create database `skills_inventory`.
- Open Query Tool → run `CamDB.sql`.
- Verify with `SELECT COUNT(*) FROM public.person;`.

Option B — `psql` on Windows PowerShell:

```powershell
psql -h localhost -U postgres -c "CREATE DATABASE skills_inventory;";
psql -h localhost -U postgres -c "CREATE ROLE skills_user WITH LOGIN PASSWORD 'changeme';";
psql -h localhost -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE skills_inventory TO skills_user;";
psql -h localhost -U postgres -d skills_inventory -f "c:\Users\Camer\OneDrive\Documents\GitHub\SkillsInventoryManagement\CamDB.sql";
```

## Environment Variables
Copy `.env.example` to `.env` and adjust:

```env
PORT=3000
NODE_ENV=development
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
LOG_LEVEL=info
```

## Install & Run

```powershell
cd backend
npm install
npm run dev
# Health check
curl http://localhost:3000/health
```

## API Overview
- `GET /health` — DB heartbeat
- `POST /api/auth/login` — JWT login
- Users: `/api/users/*`
- Skills: `/api/skills/*`
- Person skills: `/api/person-skills/*`
- Team: `/api/team/*` (includes `high-value-skills`, `my-team`, approvals)

## Login Tip (bcrypt)
Dumped passwords are hashed. To set a known password:

```powershell
node -e "const bcrypt=require('bcrypt');bcrypt.hash('admin123',10).then(h=>console.log(h))";
psql -h localhost -U postgres -d skills_inventory -c "UPDATE public.person SET password='<HASH>' WHERE username='mylo.hobbs';";
```

## Notes
- CORS defaults to `http://localhost:5173` for the Vite dev server.
