FROM python:3-alpine

ENV REPO_DIR=/data

RUN apk add --update --no-cache openssh ansible \
 && ansible-galaxy collection install community.general vyos.vyos

# switch to non privileged user
ENV HOME=/home/worker
RUN mkdir -p ${HOME} \
 && addgroup -S worker \
 && adduser -S worker -G worker
WORKDIR ${HOME}
USER worker

COPY --chown=worker:worker . ${HOME}
RUN find /home/worker -name '*.sh' -exec chmod +x {} \;

ENTRYPOINT ["/bin/sh", "/home/worker/entrypoint.sh"]
