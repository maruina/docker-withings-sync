#!/bin/bash

set -euo pipefail

SYNC_INTERVAL="${SYNC_INTERVAL:-21600}"
DATA_DIR="${DATA_DIR:-/data}"

if ! command -v jq &>/dev/null; then
    echo "FATAL: jq is not installed -- structured logging requires jq" >&2
    exit 1
fi

# Emit a structured JSON log line to stdout (requires jq).
# Datadog auto-parses JSON logs using the reserved attributes: timestamp, status, message.
# Extra fields can be passed as jq --arg/--argjson flags after the message.
# Falls back to plain-text on stderr if jq fails, so the container never dies silently.
log() {
    local status="$1" message="$2"
    shift 2
    if ! jq -nc \
        --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
        --arg status "$status" \
        --arg message "$message" \
        "$@" \
        '$ARGS.named' 2>/dev/null
    then
        echo "LOG_FALLBACK: status=$status message=$message" >&2
    fi
}

# Validate SYNC_INTERVAL is a positive integer (zero is not permitted).
if ! [[ "${SYNC_INTERVAL}" =~ ^[1-9][0-9]*$ ]]; then
    log "error" "SYNC_INTERVAL must be a positive integer" --arg sync_interval "${SYNC_INTERVAL}"
    exit 1
fi

# Validate DATA_DIR exists and is writable.
if [ ! -d "${DATA_DIR}" ]; then
    log "error" "DATA_DIR does not exist" --arg data_dir "${DATA_DIR}"
    exit 1
fi
if [ ! -w "${DATA_DIR}" ]; then
    log "error" "DATA_DIR is not writable" --arg data_dir "${DATA_DIR}"
    exit 1
fi

export HOME="${DATA_DIR}"

log "info" "Container started" \
    --argjson sync_interval "${SYNC_INTERVAL}" \
    --arg data_dir "${DATA_DIR}"

while true;
do
    log "info" "Starting withings-sync"
    # Suppress log lines containing 'garmin_password' to reduce credential exposure.
    # Use sed instead of grep -v to avoid exit code 1 when all lines are filtered,
    # which would cause false error reports under pipefail.
    # Each output line is wrapped in JSON via the log function.
    # Under pipefail, the pipeline returns the rightmost non-zero exit code.
    # sed always exits 0. The while-read subshell exits 0 when log (jq) succeeds
    # on every line, so in normal operation withings-sync's exit code propagates.
    if ! /usr/local/bin/withings-sync -v 2>&1 \
        | sed '/garmin_password/d' \
        | while IFS= read -r line; do log "info" "$line" --arg source "withings-sync"; done
    then
        log "error" "withings-sync failed" --argjson exit_code "$?"
    fi
    log "info" "Finished withings-sync" --argjson next_run_seconds "${SYNC_INTERVAL}"
    sleep "${SYNC_INTERVAL}"
done
