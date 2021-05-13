#!/bin/bash

set -eu

while true; do
    withings-sync
    echo "Command completed. Sleeping ${SLEEP} seconds..."
    sleep "${SLEEP}"
done