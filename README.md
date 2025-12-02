# Skills Inventory and Catalog System

**SE 4485: Software Engineering Projects – Fall 2025**  
**Sponsoring Company:** Sabre Corporation  
**Group 5 Members:** Cameron Gai, Sam Elenjickal, Tsion Dessie, Tri Dang, Dhrasti Amin, Abby Arce

---

##  Project Overview
A web-based platform for managing employee skill profiles, supporting organizational growth through tracking, approval workflows, and reporting.

**Core features:**
- Employee skill profiles and updates  
- Manager approvals and search by skill/team  
- Admin data audits, imports, and backups  
- Role-based interfaces for Employee / Manager / Admin  

---

##  Architecture
- **Frontend:** React.js  
- **Backend:** Node.js + Express.js  
- **Database:** PostgreSQL  
- **Architecture Style:** Layered + Client-Server + Repository + Component-based  

---

## Repository Structure
| Folder | Description |
|--------|--------------|
| `docs/` | Requirements, Architecture, and Detailed Design docs |
| `frontend/` | React-based UI Layer |
| `backend/` | Express server and business logic |
| `database/` | SQL schema and seed data |
| `scripts/` | Backup, restore, and deployment utilities |

**Key scripts**
- `scripts/bootstrap_sim_env.ps1` – spins up the Dockerized Postgres instance, loads `scripts/seed.xlsx`, randomizes personal skills, and assigns team priorities so you can mirror the demo dataset locally with one command.
- `scripts/xlsxtoDB.py` – ingests the Excel workbook into Postgres.
- `scripts/assign_random_skills.py` – randomizes per-person skill inventories with realistic metadata.
- `scripts/randomize_team_focus.py` – assigns high-value priorities for each manager/team.
- `scripts/set_default_passwords.js` – hashes the shared password for all seeded accounts so logins succeed immediately.

--

## Setup & Initialization
1. Clone the repository
2. Backend setup
	- `cd backend && npm install`
	- Copy `.env.example` to `.env` and adjust values if needed
	- Start the API in one terminal: `npm run dev`
3. Frontend setup
	- `cd frontend && npm install`
	- Copy `.env.example` to `.env` (defaults to `VITE_API_URL=http://localhost:3000/api`)
	- Start Vite in a second terminal: `npm run dev`
4. Visit the Vite URL (default `http://localhost:5173`) and sign in using accounts from your seeded database.

> All seeded accounts share the password defined by `DEFAULT_USER_PASSWORD` (default `Password123!`). Change that variable before seeding if you need a different default.

### Optional: Bootstrap demo database via Docker
```
powershell -ExecutionPolicy Bypass -File scripts/bootstrap_sim_env.ps1
```
The script checks that Docker Desktop is running, pulls the `postgres:15` image, provisions the `sim-postgres` container + `sim-postgres-data` volume, and seeds demo data by chaining `xlsxtoDB.py`, `assign_random_skills.py`, and `randomize_team_focus.py`. Run it from PowerShell (Windows Terminal or VS Code) before launching the backend if you want the ready-made dataset.

> The bootstrapper wipes and recreates the `sim-postgres-data` volume each run so you always get a clean seed. Pass `-PreserveVolume` if you need to keep existing data.
