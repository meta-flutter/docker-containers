FROM ubuntu:20.04

ARG REVISION=Master
ARG CMAKE_VERSION=3.19.0
ARG TZ=America/Los_Angeles
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"

USER root

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get update && apt-get install -y tzdata gawk wget git-core diffstat \
            unzip curl rpm texinfo gcc-multilib build-essential chrpath socat \
            cpio python python-git-doc python3 python3-pip python3-pexpect \
            python3-virtualenv p7zip-full p7zip-rar \
            python3-git python3-jinja2 xz-utils debianutils iputils-ping \
            xterm locales libdatetime-perl libxml-simple-perl libdigest-md5-perl \
            nano gettext cmake libjson-c-dev libmicrohttpd-dev rapidjson-dev \
            libegl1-mesa libsdl1.2-dev libxkbcommon-dev \
            xsltproc docbook-utils fop dblatex xmlto \
            lsb-release wget software-properties-common \
            jq sudo

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

RUN adduser --disabled-password --gecos '' dev
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
    gpg --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
    gpg --keyserver pgp.key-server.io --recv-keys "$key" || \
    gpg --keyserver hkp://keys.gnupg.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
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
