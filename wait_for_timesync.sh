#!/bin/sh
echo "Waiting for timesync"
while [[ "$(timedatectl status | grep 'System clock synchronized' | awk '{print $4}')" != "yes" ]]; do sleep 1; done
