FROM ubuntu:20.04

ARG TZ=America/Los_Angeles
ENV DEBIAN_FRONTEND=noninteractive
ARG RUNNER_USER_UID=1001
ARG DOCKER_GROUP_GID=121

USER root

RUN apt-get update
RUN apt-get install -y locales openssh-client git git-core
RUN apt-get install -y sudo python3 python3-pip python3-git python3-virtualenv

# Runner user
RUN adduser --disabled-password --gecos '' -u $RUNNER_USER_UID dev \
    && groupadd docker --gid $DOCKER_GROUP_GID \
    && usermod -aG sudo dev \
    && usermod -aG docker dev \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

RUN chown -R dev:dev /home/dev

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

USER dev

WORKDIR /home/dev

#
# Install workspace automation
#
RUN git clone https://github.com/meta-flutter/workspace-automation.git
WORKDIR /home/dev/workspace-automation
ENV PREFER_LLVM=14
RUN ./flutter_workspace.py
