#!/bin/bash
set -e

run_vm.sh \
  -serial null \
  -daemonize

wait_ssh.sh

rsync -avr \
  --exclude ".git" \
  --exclude ".rm-docker-repo" \
  --filter=':- .gitignore' \
  /src/. \
  root@localhost:/src

ssh root@localhost 'bash -l -c /opt/bin/build.sh'

rsync -avr root@localhost:/src/. /src

save_vm.sh
