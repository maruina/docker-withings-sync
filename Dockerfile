FROM python:3.9.5-slim-buster

ARG WITHINGS_SYNC_COMMIT=9153773e4e2ad32ce05f4d2a87c6eb9e8ed80ae2
ARG TINI_VERSION=v0.19.0
ARG GIT_VERSION=1:2.20.1-2+deb10u3
ARG CRON_VERSION=3.0pl1-134+deb10u1
ARG CURL_VERSION=7.64.0-4+deb10u2

RUN apt-get update && \
    apt-get install -y --no-install-recommends git="${GIT_VERSION}" cron="${CRON_VERSION}" curl="${CURL_VERSION}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /tini && \
    chmod +x /tini && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_COMMIT}"

COPY entrypoint.sh /entrypoint.sh
COPY withings-sync /etc/cron.d/withings-sync

RUN chmod 0644 /etc/cron.d/withings-sync

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint.sh"]
