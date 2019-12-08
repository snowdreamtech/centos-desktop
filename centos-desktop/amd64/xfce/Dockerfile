FROM snowdreamtechamd64/centos:8

LABEL maintainer="snowdream <sn0wdr1am@icloud.com>"

ENV DISPLAY=:1 \
    GEOMETRY=1024x768 \
    DEPTH=24 \
    VNC_PORT=5901\
    VNC_PASSWORD=rootgo

RUN dnf -y update \
    && dnf -y groupinstall workstation  --allowerasing --nobest \
    && dnf -y install tigervnc-server tigervnc-server-module\
    && dnf -y install Xvfb \
    && dnf clean all

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

EXPOSE 5901

ENTRYPOINT ["docker-entrypoint.sh"]
