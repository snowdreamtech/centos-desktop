FROM snowdreamtecharm64v8/centos:8

LABEL maintainer="snowdream <sn0wdr1am@icloud.com>"

COPY qemu-aarch64-static /usr/bin

ENV DISPLAY=:1 \
    RESOLUTION=1920x1080x24 \
    FLASHPLAYER_VERSION=32.0.0.293 \
    VNC_PORT=5901\
    VNC_PASSWORD=root

RUN apk add --no-cache bash bash-completion centos-desktop xfce4-terminal \
    faenza-icon-theme libc6-compat xvfb x11vnc \
    freetype ttf-freefont wqy-zenhei@testing \ 
    && rm -rf /tmp/* /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]