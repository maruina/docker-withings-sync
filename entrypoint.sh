#!/bin/bash

set -eu
echo "$(date): Container started"

while true;
do
    echo "$(date): Starting withings-sync"
    if ! /usr/local/bin/withings-sync -v >> /var/log/withings-sync.log 2>&1
    then
        echo "$(date): Error occurred during withings-sync"
        # Avoid logging garmin_password to stdout
        cat /var/log/withings-sync.log | grep -v garmin_password
    fi
    echo "$(date): Finished withings-sync, next run in 6 hours"
    sleep 21600 # 6h
done
