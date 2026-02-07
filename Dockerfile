FROM python:3.13-slim-bookworm AS builder

ARG WITHINGS_SYNC_COMMIT=14b4ac90454948d80192bbfb6493842c7490d542

RUN apt-get update && \
    apt-get install -y --no-install-recommends git libxml2-dev libxslt-dev gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_COMMIT}"

FROM python:3.13-slim-bookworm

ARG TINI_VERSION=v0.19.0

# Install tini for proper PID 1 signal handling and runtime dependencies for lxml.
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl libxml2 libxslt1.1 && \
    curl -sL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /tini && \
    chmod +x /tini && \
    apt-get purge -y --auto-remove curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin/withings-sync /usr/local/bin/withings-sync

ENV SYNC_INTERVAL=21600
ENV DATA_DIR=/data

RUN groupadd -r withings && useradd -r -g withings -d /data -s /sbin/nologin withings && \
    mkdir -p /data && chown withings:withings /data

COPY entrypoint.sh /entrypoint.sh

USER withings

# Use -g to send signals to the entire process group so sleep is interrupted
# on SIGTERM, allowing the container to shut down gracefully.
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
