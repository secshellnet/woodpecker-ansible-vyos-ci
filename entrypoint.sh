#!/bin/sh

# environment variables VYOS_PASSWORD and SSH_KEY are available through woodpecker secrets

# first we are going to save the contents of SSH_KEY as valid ssh key
mkdir -p /home/worker/.ssh/
printf "${SSH_KEY}" > /home/worker/.ssh/id_ed25519
chown worker:worker /home/worker/.ssh/id_ed25519
chmod 400 /home/worker/.ssh/id_ed25519
cat <<_EOF > /home/worker/.ssh/config
Host *
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    IdentityFile /home/worker/.ssh/id_ed25519
    Hostname 10.0.50.3
    User vyos

Host pve0.secshell.net
    Hostname 10.0.51.255
    User root
_EOF

/home/worker/lock.sh

ansible-playbook vyos.yml -vvv \
  --limit vyos.pve0.secshell.net

/home/worker/unlock.sh

${@}
