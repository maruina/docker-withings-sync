#!/bin/bash

set -eu

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "Trapped CTRL-C, exiting"
        exit 0
}

echo "Starting cron..."
/etc/init.d/cron start

while true;
do
    echo "Container up and running..."
    sleep 86400
done
