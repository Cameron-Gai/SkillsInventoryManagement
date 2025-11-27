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
- `JWT_SECRET`
- `JWT_EXPIRES_IN` (default `24h`)
- `API_VERSION` (default `v1`)
- `API_BASE_URL` (default `/api`)
- `CORS_ORIGIN` (default `http://localhost:3000`)
- `LOG_LEVEL` (default `info`)

## Project Structure
- `server.js` – Express application entry point, middleware, error handling, and server bootstrap.
- `src/config/config.js` – Environment-based configuration values used throughout the backend.

## Notes
- Additional routes, controllers, services, and database integrations can be added under `src/` following the layered architecture outlined in the root project README.
