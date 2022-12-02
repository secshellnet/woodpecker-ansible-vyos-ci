#!/bin/sh

echo -n "Resetting vyos-cicd.pve0.secshell.net, ..."
ssh \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -i /home/worker/.ssh/id_ed25519 \
  root@pve0.secshell.net /usr/bin/expect <<_EOF &> /dev/null
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
# Temporarly until these groups are managed by the dynamic ansible inventory...
send -- "set firewall group network-group NET-GITHUB\r"
send -- "set firewall group network-group NET-GOOGLE\r"
send -- "set firewall group network-group NET-CLOUDFLARE\r"
send -- "set firewall group ipv6-network-group NET-GITHUB-6\r"
send -- "set firewall group ipv6-network-group NET-GOOGLE-6\r"
send -- "set firewall group ipv6-network-group NET-CLOUDFLARE-6\r"
# END of temporarly
send -- "set service ssh\r"
send -- "set login \r"
send -- "commit\r"
send -- "save\r"
send -- "sudo dhclient eth0\r"
send -- "exit\r"
expect "$ "
send -- "exit\r"
expect "login: "
_EOF
echo -e "\b\b\bdone!"
