#!/bin/sh
if [[ "$(timedatectl status | grep 'NTP service:' | awk '{print $3}')" == "active" ]];then
  echo "Waiting for timesync"
  timedatectl set-ntp no || true
  timedatectl set-ntp yes;
  while [[ "$(timedatectl status | grep 'System clock synchronized' | awk '{print $4}')" != "yes" ]]; do
    sleep 1;
  done;
fi;
