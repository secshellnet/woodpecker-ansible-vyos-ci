#!/bin/bash

# environment variables VYOS_PASSWORD is available through woodpecker secrets

source /home/worker/.functions.sh

#function clean_exit {
#  unlock
#  exit 1
#}
# TODO find out which signal the "Cancle" Button in the webinterface uses and trap clean_exit
#trap 'echo sigint' SIGINT
#trap 'echo sigkill' SIGKILL
#trap 'echo sigquit' SIGQUIT
#trap 'echo sigterm' SIGTERM

# afterwards we create the lockfile, to make sure we are the only job which can use the vm at the moment
lock
echo

for host in ${HOSTS}; do
    # reset vyos for the next run
    reset $(echo ${host} | cut -d "." -f2)
    ansible-playbook vyos.yml --limit ${host} --extra-vars 'ansible_command_timeout=500'
    status=$((status+${?}))
    echo -e "\n\n\n"
done

unlock

# exit with code 1 if status (aka error counter) is > 1
[ ${status} -ge 1 ] && exit 1 || exit 0
