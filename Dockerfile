FROM quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z

# Render provides PORT at runtime. MinIO must listen on that port.
CMD ["sh", "-c", "minio server /data --address :${PORT:-9000}"]
