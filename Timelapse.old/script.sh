#!/bin/bash

my_dir="$(dirname "$0")"

# Include common functions
. ${my_dir}/../scripts/util/common.sh

# Include configuration
. ${my_dir}/config.conf

function capture_snapshot {
    local SNAPSHOT_FILENAME="${SNAPSHOT_LOCATION}/$(${SNAPSHOT_NAME})$1.jpg"
    local SNAPSHOT_TEXT="$(${TEXT})"
    local COMMAND="ffmpeg -loglevel panic -f video4linux2 -s ${FRAME_SIZE} -i ${INPUT_DEVICE} -vf drawtext="fontfile=${TEXT_FONT}:text=${SNAPSHOT_TEXT}:${TEXT_OPTIONS}" -vframes 1 ${SNAPSHOT_FILENAME}"
    # logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND}
    logInfo "Snapshot ${SNAPSHOT_FILENAME} captured"
}
# capture_snapshot "SNAPSHOT_NAME_MODIFIER"

function render_timelapse {
    local TIMELAPSE_FILENAME="${TIMELAPSE_LOCATION}/$(${TIMELAPSE_NAME})$1.mp4"
    local COMMAND="ffmpeg -loglevel panic -framerate ${TIMELAPSE_FRAMERATE} -pattern_type glob -i '${SNAPSHOT_LOCATION}/*.jpg' -c:v libx264 -r 30 -pix_fmt yuv420p ${TIMELAPSE_FILENAME}"
    # logInfo "Executing command: ${COMMAND}"
    eval ${COMMAND}
    logInfo "Timelapse ${TIMELAPSE_FILENAME} rendered"
}
# render_timelapse "TIMELAPSE_NAME_MODIFIER"


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--capture)
    rm -rf ${SNAPSHOT_LOCATION} && mkdir ${SNAPSHOT_LOCATION}
    for ((i=1;i<=${SNAPSHOT_COUNT};i++)); 
    do 
        capture_snapshot "-$i"
        sleep ${SNAPSHOT_PERIOD}
    done
    shift # past argument
    shift # past value
    ;;
    -r|--render)
    rm -rf ${TIMELAPSE_LOCATION} && mkdir ${TIMELAPSE_LOCATION}
    render_timelapse
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