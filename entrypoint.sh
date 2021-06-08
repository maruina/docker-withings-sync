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

echo "Setting environment variables for cron..."
printenv | sed 's/^\(.*\)$/export \1/g' > /root/cron_env.sh

while true;
do
    echo "Container up and running..."
    sleep 86400
done
