#!/bin/bash

set -eu

garmin_username="${GARMIN_USERNAME:-UNSET}"
garmin_password="${GARMIN_PASSWORD:-UNSET}"
env_file="/root/env.sh"
cron_file="/etc/cron.d/withings-sync"

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "Trapped CTRL-C, exiting"
        exit 0
}

echo "Starting cron..."
/etc/init.d/cron start

echo "Setting environment variables for cron..."
touch "${env_file}"
echo "export GARMIN_USERNAME=${garmin_username}" >> "${env_file}"
echo "export GARMIN_PASSWORD=${garmin_password}" >> "${env_file}"

echo "Setting up cronjob..."
cat << EOF > "${cron_file}"
0 10 * * * root . "${env_file}"; /usr/local/bin/withings-sync -v >> /var/log/withings-sync.log 2>&1
EOF
chmod 0644 "${cron_file}"

while true;
do
    echo "Container up and running..."
    sleep 86400
done
