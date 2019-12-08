#!/bin/sh
set -e

RESOLUTION="${GEOMETRY}x${DEPTH}"

if [ ! -f "/root/.Xauthority" ]; then
    touch /root/.Xauthority
fi

if [ ! -d "/root/.vnc" ]; then
    mkdir /root/.vnc
fi

printf "${VNC_PASSWORD}\n${VNC_PASSWORD}\n\n" | vncpasswd

nohup /usr/bin/Xvfb $DISPLAY -screen 0 $RESOLUTION -ac +extension GLX +render -noreset > /dev/null 2>&1 &
sleep 5
# nohup startx > /dev/null 2>&1 &
nohup gnome-session > /dev/null 2>&1 &
sleep 2
vncserver $DISPLAY -autokill -geometry ${GEOMETRY} -depth ${DEPTH}