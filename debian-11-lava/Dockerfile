FROM debian:11

ARG TZ=America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"
ARG RUNNER_UID=1018

USER root

RUN apt update
RUN apt install -y apt-utils
RUN apt install -y postgresql
RUN apt install -y lava-server

RUN a2dissite 000-default
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2ensite lava-server.conf
RUN service apache2 restart

RUN adduser --disabled-password --gecos '' -u ${RUNNER_UID} dev
RUN chown -R dev:dev /home/dev

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get update && apt-get install -y git-lfs

USER dev

WORKDIR /home/dev

RUN echo '/home/dev/.ssh/id_rsa' | ssh-keygen -t rsa -b 2048 -C "${USER_EMAIL}"
RUN git config --global user.email ${USER_EMAIL}
RUN git config --global user.name "${USER_NAME}"
