FROM python:3.13-slim-bookworm

ARG WITHINGS_SYNC_COMMIT=14b4ac90454948d80192bbfb6493842c7490d542
ARG TINI_VERSION=v0.19.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl libxml2-dev libxslt-dev gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" -o /tini && \
    chmod +x /tini && \
    pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_COMMIT}"

ENV SYNC_INTERVAL=21600
ENV DATA_DIR=/data

RUN mkdir -p /data

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint.sh"]
