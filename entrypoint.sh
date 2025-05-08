#!/bin/bash

set -eu
echo "$(date): Container started"

while true;
do
    echo "$(date): Starting withings-sync" >> /var/log/withings-sync.log
    /usr/local/bin/withings-sync -v >> /var/log/withings-sync.log 2>&1
    echo "$(date): Finished withings-sync" >> /var/log/withings-sync.log
    sleep 21600 # 6h
done
