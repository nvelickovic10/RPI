#!/bin/bash

my_dir="$(dirname "$0")"

# Include common functions
. ${my_dir}/../scripts/util/common.sh

# Include configuration
. ${my_dir}/config.conf

# Check if running as root
if [ "$EUID" -ne 0 ]
    then logInfo "Please run as root"
    exit
fi

mkdir -p ${PID_LOCATION} && mkdir -p ${LOG_LOCATION}

function start_webserver_process {
    local START_TIMESTAMP=`date +%s`
    
    local TIMELAPSE_PID=$(cat ${PID_LOCATION}/timelapse.pid)
    local COMMAND="motion -c motionOnlyWebserver.conf &> ${LOG_LOCATION}/webserver.log"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND} &
    local WEBSERVER_PID=$!
    echo ${WEBSERVER_PID} > ${PID_LOCATION}/webserver.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Webserver  process ${TIMELAPSE_PID} started, RUNTIME: ${RUNTIME}"
}

function stop_webserver_process {
    local START_TIMESTAMP=`date +%s`
    
    local WEBSERVER_PID=$(cat ${PID_LOCATION}/webserver.pid)
    local COMMAND="kill -9 ${WEBSERVER_PID} ; kill -9 $(pgrep -f 'motion -c motionOnlyWebserver.conf')"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND}
    rm ${PID_LOCATION}/webserver.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Webserver process ${TIMELAPSE_PID} stopped, RUNTIME: ${RUNTIME}"
}

function start_webserver {
    local START_TIMESTAMP=`date +%s`

    if [ ! -f ${PID_LOCATION}/webserver.pid ]; then
        start_webserver_process
    else
        logInfo "Already Started!!!"
    fi
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Webserver started, RUNTIME: ${RUNTIME}"
}

function stop_webserver {
    local START_TIMESTAMP=`date +%s`
    
    if [ -f ${PID_LOCATION}/webserver.pid ]; then
        stop_webserver_process
    else
        logInfo "Already stopped!!!"
    fi

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Webserver stopped, RUNTIME: ${RUNTIME}"
}

function restart_webserver {
    local START_TIMESTAMP=`date +%s`

    stop_webserver_process && start_webserver_process
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Webserver restarted, RUNTIME: ${RUNTIME}"
}

function start_timelapse_process {
    local START_TIMESTAMP=`date +%s`

    local COMMAND="motion -c motionTimelapseNoWebserver.conf &> ${LOG_LOCATION}/timelapse.log"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND} &
    local TIMELAPSE_PID=$!
    echo ${TIMELAPSE_PID} > ${PID_LOCATION}/timelapse.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Timelapse process ${TIMELAPSE_PID} started, RUNTIME: ${RUNTIME}"
}

function stop_timelapse_process {
    local START_TIMESTAMP=`date +%s`
    
    local TIMELAPSE_PID=$(cat ${PID_LOCATION}/timelapse.pid)
    local COMMAND="kill -9 ${TIMELAPSE_PID} ; kill -9 $(pgrep -f 'motion -c motionTimelapseNoWebserver.conf')"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND}
    rm ${PID_LOCATION}/timelapse.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Timelapse process ${TIMELAPSE_PID} stopped, RUNTIME: ${RUNTIME}"
}

function start_timelapse {
    local START_TIMESTAMP=`date +%s`

    if [ ! -f ${PID_LOCATION}/timelapse.pid ]; then
        start_timelapse_process
    else
        logInfo "Already Started!!!"
    fi
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Timelapse started, RUNTIME: ${RUNTIME}"
}

function stop_timelapse {
    local START_TIMESTAMP=`date +%s`
    
    if [ -f ${PID_LOCATION}/timelapse.pid ]; then
        stop_timelapse_process
    else
        logInfo "Already stopped!!!"
    fi

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Timelapse stopped, RUNTIME: ${RUNTIME}"
}

function restart_timelapse {
    local START_TIMESTAMP=`date +%s`

    stop_timelapse_process && start_timelapse_process
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Timelapse restarted, RUNTIME: ${RUNTIME}"
}

function start_cloner_process {
    local START_TIMESTAMP=`date +%s`

    # v4l2-ctl --list-devices
    modprobe -r v4l2loopback
    modprobe v4l2loopback devices=2 

    local COMMAND="ffmpeg -f video4linux2 -s 640x480 -i /dev/video0 -codec copy -f v4l2 /dev/video1 -codec copy -f v4l2 /dev/video2 &>/dev/null"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND} &
    local CLONER_PID=$!
    echo ${CLONER_PID} > ${PID_LOCATION}/cloner.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Cloner process ${TIMELAPSE_PID} started, RUNTIME: ${RUNTIME}"
}

function stop_cloner_process {
    local START_TIMESTAMP=`date +%s`
    
    local CLONER_PID=$(cat ${PID_LOCATION}/cloner.pid)
    local COMMAND="kill -9 ${CLONER_PID} ; kill -9 $(pgrep -f 'ffmpeg -f video4linux2 -s 640x480 -i /dev/video0 -codec copy -f v4l2 /dev/video1 -codec copy -f v4l2 /dev/video2')"
    logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND} && modprobe -r v4l2loopback
    rm ${PID_LOCATION}/cloner.pid

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Cloner process ${TIMELAPSE_PID} stopped, RUNTIME: ${RUNTIME}"
}

function start_cloner {
    local START_TIMESTAMP=`date +%s`

    if [ ! -f ${PID_LOCATION}/cloner.pid ]; then
        start_cloner_process
    else
        logInfo "Already Started!!!"
    fi
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Cloner started, RUNTIME: ${RUNTIME}"
}

function stop_cloner {
    local START_TIMESTAMP=`date +%s`
    
    if [ -f ${PID_LOCATION}/cloner.pid ]; then
        stop_cloner_process
    else
        logInfo "Already stopped!!!"
    fi

    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Cloner stopped, RUNTIME: ${RUNTIME}"
}

function restart_cloner {
    local START_TIMESTAMP=`date +%s`

    stop_cloner_process && start_cloner_process
    
    local RUNTIME=$(($(date +%s)-START_TIMESTAMP))
    logInfo "Cloner restarted, RUNTIME: ${RUNTIME}"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --start-timelapse)
    start_timelapse
    shift # past argument
    shift # past value
    ;;
    --stop-timelapse)
    stop_timelapse
    shift # past argument
    shift # past value
    ;;
    --restart-timelapse)
    restart_timelapse
    shift # past argument
    shift # past value
    ;;
    --start-webserver)
    start_webserver
    shift # past argument
    shift # past valuewebserver
    ;;
    --stop-webserver)
    stop_webserver
    shift # past argument
    shift # past value
    ;;
    --restart-webserver)
    restart_webserver
    shift # past argument
    shift # past value
    ;;
    --start-cloner)
    start_cloner
    shift # past argument
    shift # past value
    ;;
    --stop-cloner)
    stop_cloner
    shift # past argument
    shift # past value
    ;;
    --restart-cloner)
    restart_cloner
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# End