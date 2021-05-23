FROM python:3.9.5-slim-buster

ARG WITHINGS_SYNC_VERSION=v3.2.0
ARG TINI_VERSION=v0.19.0
ARG GIT_VERSION=1:2.20.1-2+deb10u3

ADD "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini" /tini
RUN chmod +x /tini

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get install -y --no-install-recommends git="${GIT_VERSION}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir git+https://github.com/jaroslawhartman/withings-sync.git@"${WITHINGS_SYNC_VERSION}"

ENTRYPOINT ["/tini", "--"]

CMD ["/entrypoint.sh"]
