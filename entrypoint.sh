#!/bin/bash

set -euo pipefail

SYNC_INTERVAL="${SYNC_INTERVAL:-21600}"
DATA_DIR="${DATA_DIR:-/data}"

# Validate SYNC_INTERVAL is a positive integer (zero is not permitted).
if ! [[ "${SYNC_INTERVAL}" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: SYNC_INTERVAL must be a positive integer, got '${SYNC_INTERVAL}'"
    exit 1
fi

# Validate DATA_DIR exists and is writable.
if [ ! -d "${DATA_DIR}" ]; then
    echo "Error: DATA_DIR '${DATA_DIR}' does not exist"
    exit 1
fi
if [ ! -w "${DATA_DIR}" ]; then
    echo "Error: DATA_DIR '${DATA_DIR}' is not writable"
    exit 1
fi

export HOME="${DATA_DIR}"

echo "$(date): Container started (sync interval: ${SYNC_INTERVAL}s, data dir: ${DATA_DIR})"

while true;
do
    echo "$(date): Starting withings-sync"
    # Suppress log lines containing 'garmin_password' to reduce credential exposure.
    # Use sed instead of grep -v to avoid exit code 1 when all lines are filtered,
    # which would cause false error reports under pipefail.
    if ! /usr/local/bin/withings-sync -v 2>&1 | sed '/garmin_password/d'
    then
        echo "$(date): Error occurred during withings-sync"
    fi
    echo "$(date): Finished withings-sync, next run in ${SYNC_INTERVAL}s"
    sleep "${SYNC_INTERVAL}"
done
