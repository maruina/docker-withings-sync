FROM python:3.14-slim-bookworm AS builder

# withings-sync v5.3.0
ARG WITHINGS_SYNC_COMMIT=d4395bf88dd8619012c3e28319c092e924d66570

RUN apt-get update && \
    apt-get install -y --no-install-recommends git libxml2-dev libxslt-dev gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_COMMIT}"

FROM python:3.14-slim-bookworm

ARG TINI_VERSION=v0.19.0

# Install tini for proper PID 1 signal handling, jq for structured JSON logging,
# and libxml2/libxslt1.1 as runtime dependencies for the lxml Python package.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl jq libxml2 libxslt1.1 && \
    curl -fsSL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /tini && \
    chmod +x /tini && \
    apt-get purge -y --auto-remove curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.14/site-packages /usr/local/lib/python3.14/site-packages
COPY --from=builder /usr/local/bin/withings-sync /usr/local/bin/withings-sync

ENV SYNC_INTERVAL=21600 \
    DATA_DIR=/data

RUN groupadd -r -g 65532 withings && useradd -r -u 65532 -g withings -d /data -s /sbin/nologin withings && \
    mkdir -p /data && chown withings:withings /data

COPY --chmod=0755 entrypoint.sh /entrypoint.sh

USER withings

# The -g flag forwards signals to the child's process group, ensuring sleep(1)
# is also terminated on SIGTERM for graceful container shutdown.
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
