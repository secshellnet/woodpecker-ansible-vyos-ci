#!/bin/bash

# environment variables VYOS_PASSWORD and SSH_KEY are available through woodpecker secrets

#function clean_exit {
#  unlock
#  exit 1
#}
# TODO find out which signal the "Cancle" Button in the webinterface uses and trap clean_exit
#trap 'echo sigint' SIGINT
#trap 'echo sigkill' SIGKILL
#trap 'echo sigquit' SIGQUIT
#trap 'echo sigterm' SIGTERM

source /home/worker/.functions.sh

# first we are going to save the contents of SSH_KEY as valid ssh key
mkdir -p /home/worker/.ssh/
echo -n "${SSH_KEY}" > /home/worker/.ssh/id_ed25519
chown worker:worker /home/worker/.ssh/id_ed25519
chmod 400 /home/worker/.ssh/id_ed25519

# make git cli useable
git config --global --add safe.directory $(pwd)

# check which files have been changed in the last commit,
#  if changes have been made to a specific site it will be added to the hosts list
#  if changes have been made to all sites, all sites will be returned
hosts=$(python3 /home/worker/check_changes.py $(git diff --name-only HEAD HEAD~1 | xargs))

if [ -z $hosts ]; then
    echo "No relevant changes detected, exiting..."
    exit 0
fi

# afterwards we create the lockfile, to make sure we are the only job which can use the vm at the moment
lock
echo

for host in ${hosts}; do
    # reset vyos for the next run
    reset $(echo ${host} | cut -d "." -f2)
    ansible-playbook vyos.yml --limit ${host} --extra-vars 'ansible_command_timeout=500'
    status=$((status+${?}))
    echo -e "\n\n\n"
done

unlock

# exit with code 1 if status (aka error counter) is > 1
[ ${status} -ge 1 ] && exit 1 || exit 0
