#!/bin/sh
set -eu

API_PORT="${MINIO_API_PORT:-9000}"
CONSOLE_PORT="${MINIO_CONSOLE_PORT:-9001}"
PUBLIC_PORT="${PORT:-8080}"
PUBLIC_URL="${PUBLIC_BASE_URL:-http://localhost:${PUBLIC_PORT}}"

export MINIO_BROWSER_REDIRECT_URL="${MINIO_BROWSER_REDIRECT_URL:-${PUBLIC_URL}/console}"

minio server /data --address ":${API_PORT}" --console-address ":${CONSOLE_PORT}" &
MINIO_PID=$!

cleanup() {
    kill "${MINIO_PID}" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
