FROM ubuntu:18.04

ARG TZ=America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"
ARG RUNNER_UID=1018

USER root

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
                       build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
                       xz-utils debianutils iputils-ping

RUN apt-get install -y libsdl1.2-dev xterm

RUN apt-get install -y make xsltproc docbook-utils fop dblatex xmlto

RUN apt-get install -y python-git coreutils gettext

RUN apt-get install -y locales lsb-release software-properties-common \
                       python3-git python3-jinja2 libegl1-mesa pylint3 pylint

RUN apt-get install -y libncurses5 libncurses5-dev libncursesw5-dev libssl-dev \
                       linux-headers-generic u-boot-tools device-tree-compiler \
                       bison flex g++ libyaml-dev libmpc-dev libgmp-dev

RUN apt-get install -y bsdmainutils sed curl bc lrzsz corkscrew nano \
                       cvs subversion mercurial nfs-common nfs-kernel-server \
                       libarchive-zip-perl dos2unix texi2html diffstat libxml2-utils nano \
                       lrzsz repo rsync srecord

RUN apt-get install -y liblz4-tool zstd

RUN apt-get install -y libxml-simple-perl

# Make bash the default shell
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash


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

RUN set -ex \
  && for key in C6C265324BBEBDC350B513D02D2CEF1034921684; do \
    gpg --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done

# install for python 2
RUN set -ex \
  && mkdir -p /home/dev/bin \
  && export PATH=/home/dev/bin:$PATH \
  && curl https://storage.googleapis.com/git-repo-downloads/repo-1 > ~/bin/repo \
  && chmod a+x /home/dev/bin/repo
