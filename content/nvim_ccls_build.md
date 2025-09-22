+++
title = "构建命令行IDE：nvim、coc、ccls"
date = 2022-08-28
[taxonomies]
categories = ["VIM"]
tags = ["vim", "ccls"]
+++

Dockerfile:

```dockerfile
FROM ubuntu:20.04 AS build
COPY sources.list /etc/apt/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt-get install -y libclang-10-dev clang-10 clang libz-dev cmake gcc g++ git
RUN git clone https://github.com/MaskRay/ccls && \
	    cd ccls && git submodule init && git submodule update && \
	    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release && \
	    cmake --build Release -- install

FROM ubuntu:20.04
COPY --from=build /usr/local/bin/ccls /usr/bin/
COPY sources.list /etc/apt/
RUN  apt-get update && \
	    DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai \
	    apt-get install -y make gcc git libllvm10 ca-certificates gnupg curl
RUN echo "deb https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu focal main" >> /etc/apt/sources.list && \
	    echo "deb https://deb.nodesource.com/node_16.x focal main" >> /etc/apt/sources.list && \
	    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 55F96FCF8231B6DD && \
	    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280 && \
	    apt-get update && \
	    DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai apt-get install -y neovim nodejs cscope ctags
```

sources.list:

```
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```

https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image

https://github.com/MaskRay/ccls/wiki/Build

https://askubuntu.com/questions/291035/how-to-add-a-gpg-key-to-the-apt-sources-keyring

https://github.com/neoclide/coc.nvim

https://computingforgeeks.com/how-to-install-node-js-on-ubuntu-debian/
