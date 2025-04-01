FROM ubuntu:20.04

ARG CMAKE_VERSION=3.19.0
ARG TZ=America/Los_Angeles
ENV DEBIAN_FRONTEND=noninteractive
ARG USER_NAME="Matt Everett"
ARG USER_EMAIL="m.everett.90@gmail.com"
ARG RUNNER_USER_UID=1001
ARG DOCKER_GROUP_GID=121

USER root

RUN apt-get -y update
RUN apt-get install -y apt

RUN apt-get install -y gawk wget git diffstat unzip texinfo \
            gcc build-essential chrpath socat cpio python3 \
            python3-pip python3-pexpect xz-utils debianutils \
            iputils-ping python3-git python3-jinja2 libegl1-mesa \
            libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev \
            zstd liblz4-tool python
RUN apt-get install -y tzdata git-core \
            curl gcc-multilib \
            python3-virtualenv p7zip-full p7zip-rar jq \
            python3-git python3-jinja2 xz-utils iputils-ping \
            xterm locales libdatetime-perl libxml-simple-perl libdigest-md5-perl \
            nano gettext cmake libjson-c-dev libmicrohttpd-dev rapidjson-dev \
            libxkbcommon-dev \
            xsltproc docbook-utils fop dblatex xmlto \
            lsb-release software-properties-common rsync srecord gdisk \
            lz4 libmpc-dev pylint bsdmainutils libgmp-dev  libssl-dev \
            file procps sudo 

RUN apt-get install -y at-spi2-core binutils binutils-aarch64-linux-gnu \
            binutils-arm-linux-gnueabihf binutils-mips64el-linux-gnuabi64 binutils-mipsel-linux-gnu \
            bison bzip2 cdbs curl dbus-x11 devscripts dpkg-dev elfutils fakeroot flex git-core gperf \
            lib32gcc-s1 lib32stdc++6 lib32z1 libasound2 libasound2-dev libatk1.0-0 libatspi2.0-0 \
            libatspi2.0-dev libbluetooth-dev libbrlapi-dev libbrlapi0.7 libbz2-1.0 libbz2-dev \
            libc6 libc6-dev libc6-i386 libcairo2 libcairo2-dev libcap-dev libcap2 \
            libcgi-session-perl libcups2 libcups2-dev libcurl4-gnutls-dev libdrm-dev libdrm2 \
            libegl1 libelf-dev libevdev-dev libevdev2 libexpat1 libffi-dev libffi7 libfontconfig1 \
            libfreetype6 libfuse2 libgbm-dev libgbm1 libgl1 libglib2.0-0 libglib2.0-dev \
            libglu1-mesa-dev libgraphene-1.0-0 libgtk-3-0 libgtk-3-dev libinput-dev libinput10 \
            libjpeg-dev libkrb5-dev libncurses6 libnspr4 libnspr4-dev libnss3 libnss3-dev \
            libpam0g libpam0g-dev libpango-1.0-0 libpangocairo-1.0-0 libpci-dev libpci3 libpcre3 \
            libpixman-1-0 libpng16-16 libpulse-dev libpulse0 libsctp-dev libspeechd-dev libspeechd2 \
            libsqlite3-0 libsqlite3-dev libssl-dev libstdc++6 libsystemd-dev libudev-dev libudev1 \
            libuuid1 libva-dev libvulkan-dev libvulkan1 libwayland-egl1 libwayland-egl1-mesa \
            libwww-perl libx11-6 libx11-xcb1 libxau6 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
            libxdmcp6 libxext6 libxfixes3 libxi6 libxinerama1 libxkbcommon-dev libxrandr2 libxrender1 \
            libxshmfence-dev libxslt1-dev libxss-dev libxt-dev libxtst-dev libxtst6 lighttpd locales \
            mesa-common-dev mutter-common openbox p7zip patch perl pkgconf rpm ruby uuid-dev wdiff \
            x11-utils x11-xserver-utils xcompmgr xserver-xorg-core xserver-xorg-video-dummy xvfb \
            xz-utils zip zlib1g zstd


RUN curl 'https://chromium.googlesource.com/chromium/src/+/main/build/install-build-deps.py?format=TEXT' | base64 -d > install-build-deps.py

RUN pip3 install virtualenv dataclasses importlib_metadata

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