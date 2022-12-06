FROM python:3-alpine

COPY ansible.patch /tmp

RUN apk add --update --no-cache openssh-client gcc musl-dev libssh-dev bash git patch \
 && python3 -m pip install ansible==6.6.0 pyyaml ansible-pylibssh requests aggregate_prefixes \
 && ansible-galaxy collection install community.general \
 && patch /usr/local/lib/python3.11/site-packages/ansible_collections/vyos/vyos/plugins/module_utils/network/vyos/facts/firewall_rules/firewall_rules.py < /tmp/ansible.patch

# switch to non privileged user
RUN mkdir -p /home/worker \
 && addgroup -S worker \
 && adduser -S worker -G worker
WORKDIR /home/worker
USER worker

COPY --chown=worker:worker . /home/worker

RUN find /home/worker -name '*.sh' -exec chmod +x {} \;

ENTRYPOINT ["/bin/bash", "/home/worker/entrypoint.sh"]
