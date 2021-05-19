#!/bin/bash

set -eu

sleep="${SLEEP:-900}"
verbose="${VERBOSE:-false}"

if [[ ${verbose} == "true" ]]; then
    args="-v"
    echo "sleep value: ${sleep}"
    echo "withings-sync arguments: ${args}"
fi


while true; do
    withings-sync "${args}"
    echo "Command completed. Sleeping ${sleep} seconds..."
    sleep "${sleep}"
done
