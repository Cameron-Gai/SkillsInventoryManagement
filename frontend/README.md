# Skills Inventory Frontend

Vite-powered React SPA for Skills Inventory Management.

## Prerequisites
- Node.js 18+
- Backend running at `http://localhost:3000`

## Configure API Base URL
This app uses `VITE_API_URL` as its base. The backend mounts routes at `/api` (not `/api/v1`).

Create `frontend/.env`:

```env
VITE_API_URL=http://localhost:3000/api
```

## Getting started
```powershell
cd frontend
npm install
npm run dev
# open http://localhost:5173
```

## Build & Preview
```powershell
npm run build
npm run preview
```

## Lint
```powershell
npm run lint
```

## Project structure
- `src/api/*` – Axios clients (`axiosInstance` injects `Authorization` header when present)
- `src/pages/*` – Login, Dashboard, Team, Admin views
- `src/routes/*` – Router + protected route wrapper
- `src/components/*` – UI building blocks

## Verify end-to-end
1) Import DB via `CamDB.sql` (see root README).
2) Start backend (`npm run dev` in `backend/`).
3) Start frontend (`npm run dev` in `frontend/`).
4) If you need a known password, set one via bcrypt and SQL (see root README).

## Notes
- CORS default in backend is `http://localhost:5173`.
- If you see requests to `/api/v1`, set `VITE_API_URL` as above.

