FROM quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z AS minio

FROM nginx:1.27-alpine

COPY --from=minio /usr/bin/minio /usr/bin/minio
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/start.sh"]
