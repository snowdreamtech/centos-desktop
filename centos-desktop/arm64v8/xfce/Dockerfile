FROM snowdreamtecharm64v8/centos:7

LABEL maintainer="snowdream <sn0wdr1am@icloud.com>"

COPY qemu-aarch64-static /usr/bin

ENV DISPLAY=:1 \
    GEOMETRY=1024x768 \
    DEPTH=24 \
    VNC_PORT=5901\
    VNC_PASSWORD=rootgo

RUN yum -y update \
    && yum install -y epel-release \
    && yum groupinstall -y "Xfce" \
    && yum install -y tigervnc-server tigervnc-server-module\
    && yum install -y Xvfb xdpyinfo wmctrl\
    && yum clean all

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

EXPOSE 5901 5902

ENTRYPOINT ["docker-entrypoint.sh"]