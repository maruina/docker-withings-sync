#!/bin/bash

set -euo pipefail

SYNC_INTERVAL="${SYNC_INTERVAL:-21600}"
DATA_DIR="${DATA_DIR:-/data}"

# Validate SYNC_INTERVAL is a positive integer.
if ! [[ "${SYNC_INTERVAL}" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: SYNC_INTERVAL must be a positive integer, got '${SYNC_INTERVAL}'"
    exit 1
fi

export HOME="${DATA_DIR}"

echo "$(date): Container started (sync interval: ${SYNC_INTERVAL}s, data dir: ${DATA_DIR})"

while true;
do
    echo "$(date): Starting withings-sync"
    # Filter credentials from log output.
    if ! /usr/local/bin/withings-sync -v 2>&1 | grep -v garmin_password
    then
        echo "$(date): Error occurred during withings-sync"
    fi
    echo "$(date): Finished withings-sync, next run in ${SYNC_INTERVAL}s"
    sleep "${SYNC_INTERVAL}"
done
