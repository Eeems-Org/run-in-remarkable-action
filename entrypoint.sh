#!/bin/bash
set -e

run_vm \
  -serial null \
  -daemonize

wait_ssh

rsync -avr \
  --exclude ".git" \
  --exclude ".rm-docker-repo" \
  --filter=':- .gitignore' \
  /src/. \
  root@localhost:/opt/tmp/src

ssh root@localhost 'bash -l -c /opt/bin/run.sh'

rsync -avr root@localhost:/opt/tmp/src/. /src

save_vm
