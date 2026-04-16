# MinIO Server (Local + Render)

## Render one-domain setup

This project uses Caddy as a reverse proxy so Render can expose MinIO API and Console on one domain (one public port).

- `https://<your-render-domain>/` -> MinIO S3 API
- `https://<your-render-domain>/console` -> MinIO Console

## Deploy on Render (Docker)

1. Create a new **Web Service** from this repository.
2. Runtime: **Docker**.
3. Add environment variables:
   - `MINIO_ROOT_USER` = your admin user
   - `MINIO_ROOT_PASSWORD` = your strong password
   - `MINIO_SERVER_URL` = `https://<your-render-domain>`
   - `MINIO_BROWSER_REDIRECT_URL` = `https://<your-render-domain>/console`
4. Add a persistent disk and mount it to `/data`.
5. Deploy.

## Endpoints

- Health check: `GET /minio/health/live`
- Console: `GET /console`
- S3 API: root path `/`

## Local docker compose

For local development, continue using `docker-compose.yml` and `.env`.
