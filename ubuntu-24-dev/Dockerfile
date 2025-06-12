FROM ubuntu:24.04

ARG CMAKE_VERSION=3.31.8
ARG TZ=America/Los_Angeles
ENV DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Joel Winarske"
ARG USER_EMAIL="joel.winarske@gmail.com"
ARG RUNNER_USER_UID=1001
ARG DOCKER_GROUP_GID=121

USER root

RUN apt-get update -y
RUN apt-get install -y apt-utils

RUN apt-get update -y
RUN apt-get upgrade -y

RUN apt-get install -y \
  curl lsb-release software-properties-common gnupg apt-file \
  build-essential libtool chrpath cpio debianutils diffstat file \
  gawk gcc git iputils-ping libacl1 locales python3 python3-git \
  python3-jinja2 python3-pexpect python3-pip python3-subunit socat \
  texinfo unzip wget xz-utils zstd lz4

# Desktop specific

# clang 18
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 18 all

RUN apt-get install -y libwayland-dev wayland-protocols \
            mesa-common-dev libegl1-mesa-dev libgles2-mesa-dev \
            mesa-utils libcurl4-openssl-dev libjpeg-turbo8-dev \
            libpng-dev libsqlite3-dev libssl-dev libfreetype6-dev \
            libharfbuzz-dev libxi-dev libunwind-dev ninja-build

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

# install for python 3
RUN set -ex \
  && mkdir -p /home/dev/bin \
  && export PATH=/home/dev/bin:$PATH \
  && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo \
  && chmod a+x /home/dev/bin/repo

RUN curl -fsSLO --compressed --retry 5 --retry-max-time 120 https://cmake.org/files/v3.31/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz \
  && curl -fsSLO --compressed --retry 5 --retry-max-time 120 https://cmake.org/files/v3.31/cmake-${CMAKE_VERSION}-SHA-256.txt.asc \
  && curl -fsSLO --compressed --retry 5 --retry-max-time 120 https://cmake.org/files/v3.31/cmake-${CMAKE_VERSION}-SHA-256.txt \
  && gpg --verify cmake-${CMAKE_VERSION}-SHA-256.txt.asc cmake-${CMAKE_VERSION}-SHA-256.txt \
  && grep "cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz\$" cmake-${CMAKE_VERSION}-SHA-256.txt | sha256sum -c - \
  && mkdir -p /home/dev/cmake \
  && tar xzf cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz -C /home/dev/cmake --strip-components=1 \
  && rm -rf cmake-${CMAKE_VERSION}* || true

RUN echo 'export PATH=/home/dev/bin:/home/dev/cmake/bin:$PATH' >> /home/dev/.bashrc
