# MinIO Server (Local + Render)

## Render one-domain setup

This project uses Nginx as a reverse proxy so Render can expose MinIO API and Console on one domain (one public port).

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
   - `MINIO_PUBLIC_BUCKETS` = comma-separated buckets to auto-set public read on boot (default: `products`)
4. Add a persistent disk and mount it to `/data`.
5. Deploy.

## Endpoints

- Health check: `GET /minio/health/live`
- Console: `GET /console`
- S3 API: root path `/`

## Auto public-read policy on boot

- On startup, container uses `mc` to ensure each bucket in `MINIO_PUBLIC_BUCKETS` exists.
- Then it applies `anonymous download` policy to those buckets.
- Default behavior already sets `products` bucket to public read.

## Local docker compose

For local development, continue using `docker-compose.yml` and `.env`.
