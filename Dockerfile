FROM python:3.9.5-slim-buster

ARG WITHINGS_SYNC_COMMIT=240f6123c9eb8226fff650f22a2979867fcba00e
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
