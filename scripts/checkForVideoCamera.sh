#!/bin/bash

# Change dir to script dir
cd "$(dirname "$0")"

# Include common functions
. common.sh

SCRIPT_NAME="${0##*/}"

logInfo "STARTING ${SCRIPT_NAME}"

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
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

logInfo "FINISHED ${SCRIPT_NAME}"
# END
