FROM ubuntu:16.04

ARG CMAKE_VERSION=3.19.0
ARG TZ=America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"
ARG RUNNER_UID=1018

USER root

RUN agt-get update && \
    apt-get install -y lsb-release wget software-properties-common

RUN apt-get update && \
    apt-get install -y gawk wget git-core diffstat \
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

# Desktop specific

# clang 12
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 12

RUN apt-get install -y libwayland-dev wayland-protocols \
            mesa-common-dev libegl1-mesa-dev libgles2-mesa-dev mesa-utils \
            libcurl4-openssl-dev libjpeg-turbo8-dev libpng-dev libsqlite3-dev \
            libssl-dev libfreetype6-dev libharfbuzz-dev libxi-dev \
            libc++-12-dev libc++abi-12-dev libunwind-dev ninja-build

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

RUN set -ex \
  && curl -fsSLO --compressed https://cmake.org/files/v3.19/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz \
  && curl -fsSLO --compressed https://cmake.org/files/v3.19/cmake-${CMAKE_VERSION}-SHA-256.txt.asc \
  && curl -fsSLO --compressed https://cmake.org/files/v3.19/cmake-${CMAKE_VERSION}-SHA-256.txt \
  && gpg --verify cmake-${CMAKE_VERSION}-SHA-256.txt.asc cmake-${CMAKE_VERSION}-SHA-256.txt \
  && grep "cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz\$" cmake-${CMAKE_VERSION}-SHA-256.txt | sha256sum -c - \
  && mkdir -p /home/dev/cmake \
  && tar xzf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz -C /home/dev/cmake --strip-components=1 \
  && rm -rf cmake-${CMAKE_VERSION}*

RUN echo 'export PATH=/home/dev/bin:/home/dev/cmake/bin:$PATH' >> /home/dev/.bashrc
