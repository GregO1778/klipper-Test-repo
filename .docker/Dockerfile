FROM ubuntu:18.04 as build
LABEL authors="ggiovinazzo"

WORKDIR /build
VOLUME /build

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
    git gcc gawk flex libc6:i386 libstdc++6:i386 lib32z1 libncurses5 libncurses5-dev \
    python g++ libz-dev libssl-dev make p7zip-full && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf \
    		/tmp/* \
    		/var/cache/apt/archives/* \
    		/var/lib/apt/lists/* \
    		/var/tmp/*

COPY /rootfs /

ENTRYPOINT [ "/entrypoint.sh" ]

#CMD ["cat", "/entrypoint.sh"]