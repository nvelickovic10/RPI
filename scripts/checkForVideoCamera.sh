#!/bin/bash

my_dir="$(dirname "$0")"

# Include common functions
. ${my_dir}/util/common.sh

# Check if running as root
if [ "$EUID" -ne 0 ]
    then logInfo "Please run as root"
    exit
fi

function startMotionService {
    if [[ "${MOTION_STATUS}" == "inactive" ]]; then
        logInfo "Starting motion"
        service motion start
    else
        logInfo "Motion already started"
    fi
}

function stopMotionService {
    if [[ "${MOTION_STATUS}" == "active" ]]; then
        logInfo "Stopping motion"
        service motion stop
    else
        logInfo "Motion already stopped"
    fi
}

CAMERA_DEVICE=/dev/video0
MOTION_STATUS=$(systemctl is-active motion)

logInfo "Motion status: ${MOTION_STATUS}"

if ls -ltrh ${CAMERA_DEVICE} ; then
    startMotionService
else
    stopMotionService
fi

# END