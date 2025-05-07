#!/bin/bash

set -eu
echo "$(date): Container started"

while true;
do
    /usr/local/bin/withings-sync -v >> /var/log/withings-sync.log 2>&1
    sleep 21600 # 6h
done
