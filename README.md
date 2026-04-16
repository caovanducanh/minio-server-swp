# MinIO Server (Local + Render)

## Why Render build failed

Render Docker deploy expects a `Dockerfile` in repository root. This repo now includes one at project root.

## Deploy on Render (Docker)

1. Create a new **Web Service** from this repository.
2. Runtime: **Docker**.
3. Add environment variables:
	- `MINIO_ROOT_USER` = your admin user
	- `MINIO_ROOT_PASSWORD` = your strong password
	- `MINIO_SERVER_URL` = `https://<your-render-domain>`
	- `MINIO_BROWSER` = `off` (recommended on single-port platforms)
4. Add a persistent disk and mount it to `/data`.
5. Deploy.

## Health check

- Endpoint: `GET /minio/health/live`
- Example: `https://<your-render-domain>/minio/health/live`
- Expected: HTTP `200`

## Local docker compose

For local development, continue using `docker-compose.yml` and `.env`.
