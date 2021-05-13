FROM python:3.9.5-slim-buster

ARG WITHINGS_SYNC_VERSION=v3.1.3
ARG TINI_VERSION=v0.19.0

ENV SLEEP 900

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY entrypoint.sh /entrypoint.sh

RUN pip install withings-sync=="${WITHINGS_SYNC_VERSION}"

ENTRYPOINT ["/tini", "--"]

CMD ["/entrypoint.sh"]
