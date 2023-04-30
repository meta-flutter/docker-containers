FROM ubuntu:16.04

ARG TZ=America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"
ARG RUNNER_UID=1001

USER root

RUN apt-get update && \
    apt-get install -y lsb-release wget software-properties-common

RUN apt-get update && \
    apt-get install -y bash gawk wget git-core diffstat \
                       unzip texinfo gcc-multilib build-essential \
                       chrpath socat cpio python \
                       python3-pexpect xz-utils debianutils \
                       libxml-simple-perl dos2unix jq nano locales \
                       make xsltproc docbook-utils fop dblatex xmlto \
                       python-git realpath gettext \
                       curl android-tools-fsutils \
                       diffstat gawk gcc-multilib git iputils-ping \
                       libgmp-dev libmpc-dev libsdl1.2-dev \
                       libssl-dev pylint python3 \
                       python3-git python3-jinja2 python3-pexpect python3-pip \
                       socat texinfo unzip wget xterm xz-utils nano

RUN pip3 install virtualenv

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN apt-get update && apt-get install -y git-lfs

RUN apt autoremove
RUN apt autoclean

RUN adduser --disabled-password --gecos '' -u ${RUNNER_UID} dev
RUN chown -R dev:dev /home/dev

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

WORKDIR /bin
#RUN rm sh
#RUN ln -s bash sh

USER dev

WORKDIR /home/dev

RUN echo '/home/dev/.ssh/id_rsa' | ssh-keygen -t rsa -b 2048 -C "${USER_EMAIL}"
RUN git config --global user.email ${USER_EMAIL}
RUN git config --global user.name "${USER_NAME}"
RUN git config --global credential.helper 'cache --timeout 3600'
RUN git config --global core.autocrlf false
RUN git config --global core.filemode false
RUN git config --global color.ui false

RUN git config --global --list

# install for python 2
RUN set -ex \
  && mkdir -p /home/dev/bin \
  && export PATH=/home/dev/bin:$PATH \
  && curl https://git.codelinaro.org/clo/tools/repo/-/raw/aosp-new/repo-1/repo > ~/bin/repo \
  && chmod a+x /home/dev/bin/repo

RUN echo 'export PATH=/home/dev/bin:$PATH' >> /home/dev/.bashrc
