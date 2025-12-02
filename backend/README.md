# Skills Inventory Backend

This package hosts the Express.js backend for the Skills Inventory and Catalog System. It provides health checks, API routing, and centralized configuration for connecting to databases and other services.

## Prerequisites
- Node.js 18+ and npm
- Optional: PostgreSQL instance for persistence

## Getting Started
1. Install dependencies:
   ```bash
   npm install
   ```
2. Create a `.env` file in the `backend/` directory (see [Environment variables](#environment-variables)).
3. Start the server:
   ```bash
   npm start
   ```
   The server runs on `PORT` (defaults to `3000`) and exposes a health check at `/health`.

## Available Scripts
- `npm start` – start the Express server.
- `npm run dev` – same as `npm start` (placeholder for future dev tooling).

## API Endpoints

### Health Check
- `GET /health` – returns a JSON payload with status, timestamp, and active environment.

### Manager Approval Workflow (FR-03, FR-05)
- `GET /api/approvals/pending` - Get all pending skill submissions
- `POST /api/approvals/:skillStatusId/approve` - Approve a skill submission
- `POST /api/approvals/:skillStatusId/reject` - Reject a skill submission
- `POST /api/approvals/batch/approve` - Batch approve multiple submissions
- `GET /api/approvals/:skillStatusId/history` - Get approval history
- `GET /api/approvals/statistics` - Get approval statistics

### Talent Search (FR-09, FR-11)
- `POST /api/search/talent` - Search for talent by multiple criteria
- `POST /api/search/multiple-skills` - Search for people with all specified skills
- `POST /api/search/advanced` - Advanced search with relevance ranking
- `GET /api/search/person/:personId` - Get detailed person skill profile
- `POST /api/search/report` - Generate skill distribution report
- `POST /api/search/save` - Save a search query for reuse
- `GET /api/search/filters` - Get available filter options

For complete API documentation, visit `http://localhost:3000/api` when the server is running.

## Environment Variables
Configuration defaults are defined in `src/config/config.js`. The following variables are supported:

- `PORT` (default `3000`)
- `NODE_ENV` (default `development`)
- `DB_HOST` (default `localhost`)
- `DB_PORT` (default `5432`)
- `DB_NAME` (default `skills_inventory`)
- `DB_USER`
- `DB_PASSWORD`
- `JWT_SECRET`
- `JWT_EXPIRES_IN` (default `24h`)
- `API_VERSION` (default `v1`)
- `API_BASE_URL` (default `/api`)
- `CORS_ORIGIN` (default `http://localhost:3000`)
- `LOG_LEVEL` (default `info`)

## Project Structure
- `server.js` – Express application entry point, middleware, error handling, and server bootstrap.
- `src/config/config.js` – Environment-based configuration values used throughout the backend.
- `src/config/database.js` – Database connection handler (placeholder for PostgreSQL integration).
- `src/models/` – Data models (Skill, SkillStatus, AuditLog, Person, Team).
- `src/repositories/` – Database access layer for skills, audit logs, and search operations.
- `src/services/` – Business logic layer for approval workflows and talent search.
- `src/controllers/` – HTTP request handlers for approval and search endpoints.
- `src/routes/` – API route definitions and aggregation.

## Features Implemented

### Manager Approval Workflow
Managers can approve or reject employee skill submissions with full audit logging:
- View pending submissions
- Approve/reject individual submissions with optional reasons
- Batch approve multiple submissions
- View approval history and statistics
- All actions logged to audit trail

### Talent Search & Reporting
Advanced search functionality supporting multiple criteria:
- Search by skill name (partial match supported)
- Filter by proficiency level (Beginner, Intermediate, Advanced, Expert)
- Filter by team/department
- Filter by location
- Filter by recency (skills updated in last N days)
- Multi-skill search (find employees with ALL specified skills)
- Advanced search with relevance ranking
- Generate skill distribution reports
- View detailed employee skill profiles
- Save search queries for reuse

## Notes
- Additional routes, controllers, services, and database integrations can be added under `src/` following the layered architecture outlined in the root project README.
