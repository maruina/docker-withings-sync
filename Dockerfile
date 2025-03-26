FROM python:3.11.4-slim-buster

ARG WITHINGS_SYNC_COMMIT=99f9186e297935e0fe4d9e7a8c724c1f309b6b04
ARG TINI_VERSION=v0.19.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends git cron curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /tini && \
    chmod +x /tini && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_COMMIT}"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint.sh"]
