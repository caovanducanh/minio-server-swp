#!/bin/sh
set -eu

export PORT="${PORT:-8080}"
API_PORT="${MINIO_API_PORT:-9000}"
CONSOLE_PORT="${MINIO_CONSOLE_PORT:-9001}"
PUBLIC_PORT="${PORT}"
PUBLIC_URL="${PUBLIC_BASE_URL:-http://localhost:${PUBLIC_PORT}}"

RAW_SERVER_URL="${MINIO_SERVER_URL:-}"
case "${RAW_SERVER_URL}" in
    MINIO_SERVER_URL=*)
        RAW_SERVER_URL="${RAW_SERVER_URL#MINIO_SERVER_URL=}"
        ;;
esac
if [ -n "${RAW_SERVER_URL}" ]; then
    export MINIO_SERVER_URL="${RAW_SERVER_URL}"
fi

RAW_BROWSER_REDIRECT_URL="${MINIO_BROWSER_REDIRECT_URL:-}"
case "${RAW_BROWSER_REDIRECT_URL}" in
    MINIO_BROWSER_REDIRECT_URL=*)
        RAW_BROWSER_REDIRECT_URL="${RAW_BROWSER_REDIRECT_URL#MINIO_BROWSER_REDIRECT_URL=}"
        ;;
esac
if [ -z "${RAW_BROWSER_REDIRECT_URL}" ]; then
    RAW_BROWSER_REDIRECT_URL="${PUBLIC_URL}/console"
fi
export MINIO_BROWSER_REDIRECT_URL="${RAW_BROWSER_REDIRECT_URL}"

minio server /data --address ":${API_PORT}" --console-address ":${CONSOLE_PORT}" &
MINIO_PID=$!

WAIT_TIMEOUT_SECONDS="${MINIO_STARTUP_TIMEOUT_SECONDS:-60}"
ELAPSED_SECONDS=0

while [ "${ELAPSED_SECONDS}" -lt "${WAIT_TIMEOUT_SECONDS}" ]; do
    if ! kill -0 "${MINIO_PID}" 2>/dev/null; then
        echo "MinIO exited during startup"
        wait "${MINIO_PID}" || true
        exit 1
    fi

    if wget -q -T 1 -O /dev/null "http://127.0.0.1:${API_PORT}/minio/health/live" 2>/dev/null; then
        break
    fi

    sleep 1
    ELAPSED_SECONDS=$((ELAPSED_SECONDS + 1))
done

if [ "${ELAPSED_SECONDS}" -ge "${WAIT_TIMEOUT_SECONDS}" ]; then
    echo "Timed out waiting for MinIO readiness on :${API_PORT}"
    exit 1
fi

# Render nginx config from template with runtime PORT.
envsubst '${PORT} ${API_PORT} ${CONSOLE_PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

cleanup() {
    kill "${MINIO_PID}" 2>/dev/null || true
}

trap cleanup INT TERM EXIT

exec nginx -g 'daemon off;'
