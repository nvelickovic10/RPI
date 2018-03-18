#!/bin/bash

SCRIPT_NAME="${0##*/}"

# Check if running as root
if [ "$EUID" -ne 0 ]
    then logInfo "Please run as root"
    exit
fi

# v4l2-ctl --list-devices
modprobe -r v4l2loopback
modprobe v4l2loopback devices=2 

ffmpeg -f video4linux2 -s 640x480 -i /dev/video0 -codec copy -f v4l2 /dev/video1 -codec copy -f v4l2 /dev/video2

echo "FINISHED ${SCRIPT_NAME}"
# END
