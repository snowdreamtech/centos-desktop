#!/bin/bash

# Based on: https://medium.com/dot-debug/running-chrome-in-a-docker-container-a55e7f4da4a8

set -e

readonly G_LOG_I='[INFO]'
readonly G_LOG_W='[WARN]'
readonly G_LOG_E='[ERROR]'

main() {
    init
    launch_xvfb
    #launch_window_manager
    run_vnc_server
}

init(){
    XVFB_DISPLAY=$DISPLAY
    XVFB_SCREEN=0
    XVFB_RESOLUTION="${GEOMETRY}x${DEPTH}"
    XVFB_TIMEOUT=5
    
    VNC_SERVER_PASSWORD=$VNC_PASSWORD
    
    if [ ! -f "/root/.Xauthority" ]; then
        touch /root/.Xauthority
    fi
    
    if [ ! -d "/root/.vnc" ]; then
        mkdir /root/.vnc
    fi
    
    # create xstartup
    echo -e '#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexec startxfce4 ' > /root/.vnc/xstartup
    
    chmod +x /root/.vnc/xstartup
}

launch_xvfb() {
    # Set defaults if the user did not specify envs.
    export DISPLAY=${XVFB_DISPLAY:-:1}
    local screen=${XVFB_SCREEN:-0}
    local resolution=${XVFB_RESOLUTION:-1280x1024x24}
    local timeout=${XVFB_TIMEOUT:-5}
    
    # Start and wait for either Xvfb to be fully up or we hit the timeout.
    Xvfb ${DISPLAY} -screen ${screen} ${resolution} > /dev/null 2>&1 &
    local loopCount=0
    until xdpyinfo -display ${DISPLAY} > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} xvfb failed to start."
            exit 1
        fi
    done
}

launch_window_manager() {
    local timeout=${XVFB_TIMEOUT:-5}
    
    # Start and wait for either xfce4 to be fully up or we hit the timeout.
    startxfce4 > /dev/null 2>&1 &
    local loopCount=0
    until wmctrl -m > /dev/null 2>&1
    do
        loopCount=$((loopCount+1))
        sleep 1
        if [ ${loopCount} -gt ${timeout} ]
        then
            echo "${G_LOG_E} xfce4 failed to start."
            exit 1
        fi
    done
}

run_vnc_server() {
    printf "${VNC_PASSWORD}\n${VNC_PASSWORD}\n\n" | vncpasswd
    vncserver $DISPLAY -autokill -geometry ${GEOMETRY} -depth ${DEPTH} &
    wait $!
}

control_c() {
    echo ""
    exit
}

trap control_c SIGINT SIGTERM SIGHUP

main

exit