#!/bin/bash

function reset {
  echo "Resetting vyos-cicd.pve0.secshell.net, ..."

  if [ ! -z $1 ]; then
    lines=""
    for grp in $(curl -q https://wpm.general.$1.secshell.net/manage/vyoscli/vpn-source-groups 2> /dev/null); do
      lines+="set firewall group address-group ${grp};"
    done
    for grp in $(curl -q https://wpm.general.$1.secshell.net/manage/vyoscli/vpn-source-groups6 2> /dev/null); do
      lines+="set firewall group ipv6-address-group ${grp};"
    done
  fi

  ssh pve0.secshell.net /usr/bin/expect <<_EOF &> /dev/null
spawn qm terminal 139
expect "starting serial terminal on interface serial0 (press Ctrl+O to exit)"

# send new line to make vyos rewrite login
send -- "\r"
expect "login: "
send -- "vyos\r"
expect "Password:"
send -- "${VYOS_PASSWORD}\r"

expect "$ "
send -- "configure\r"
send -- "load /config/initial.config\r"
send -- "set interface ethernet eth0 address dhcp\r"
send -- "${lines}"
send -- "set service ssh\r"
send -- "set login \r"
send -- "commit\r"
send -- "save\r"
expect "$ "
send -- "sudo dhclient eth0\r"
send -- "exit\r"
expect "$ "
send -- "exit\r"
expect "login: "
_EOF
  echo "done!"
}

function lock {
  echo "Locking vyos-cicd.pve0.secshell.net, ..."
  ssh pve0.secshell.net /bin/bash <<_EOF 2> /dev/null
while [ -f /tmp/vyos-cicd.lock ]; do
  echo "vyos-cicd.pve0.secshell.net is already in use, sleeping"
  sleep 10
done
touch /tmp/vyos-cicd.lock
_EOF
  # will be resetted in entrypoint for the next device under test (DUT)
  #reset
  echo "done!"
}

function unlock {
  reset
  echo "Unlock vyos-cicd.pve0.secshell.net, ..."
  ssh pve0.secshell.net rm /tmp/vyos-cicd.lock 2> /dev/null
  echo "done!"
}
