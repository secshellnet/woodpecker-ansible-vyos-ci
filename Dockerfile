FROM python:3-alpine

RUN apk add --update --no-cache openssh-client gcc musl-dev libssh-dev bash git \
 && python3 -m pip install ansible==6.6.0 pyyaml ansible-pylibssh requests aggregate_prefixes \
 && ansible-galaxy collection install community.general

# switch to non privileged user
RUN mkdir -p /home/worker \
 && addgroup -S worker \
 && adduser -S worker -G worker
WORKDIR /home/worker
USER worker

COPY --chown=worker:worker . /home/worker

RUN find /home/worker -name '*.sh' -exec chmod +x {} \;

ENTRYPOINT ["/bin/bash", "/home/worker/entrypoint.sh"]
