#!/bin/sh

/home/worker/reset_vyos.sh
echo -n "Unlock vyos-cicd.pve0.secshell.net, ..."
ssh \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -i /home/worker/.ssh/id_ed25519 \
  root@pve0.secshell.net rm /tmp/vyos-cicd.lock 2> /dev/null
echo -e "\b\b\bdone!"
