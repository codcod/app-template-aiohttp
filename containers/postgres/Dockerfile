FROM postgres:16.0-alpine3.18
RUN apk add --no-cache tzdata
ENV TZ=Europe/Warsaw

# HEALTHCHECK \
#     --interval=0m30s \
#     --timeout=10s \
#     --start-period=5s \
#     --retries=5 \
#     CMD [ "pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}" ]