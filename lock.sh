#!/bin/sh

echo -n "Locking vyos-cicd.pve0.secshell.net, ..."
ssh \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -i /home/worker/.ssh/id_ed25519 \
  root@pve0.secshell.net /bin/bash <<_EOF 2> /dev/null
while [ -f /tmp/vyos-cicd.lock ]; do
  echo "vyos-cicd.pve0.secshell.net is already in use, sleeping"
  sleep 30
done
touch /tmp/vyos-cicd.lock
_EOF

echo -e "\b\b\bdone!"

/home/worker/reset_vyos.sh
