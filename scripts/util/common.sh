#!/bin/bash

SCRIPT_START_TIMESTAMP=`date +%s`

# Change dir to script dir
cd ${my_dir}

# Log end of script
# set -e
function cleanup {
  local RUNTIME=$(($(date +%s)-SCRIPT_START_TIMESTAMP))
  echo
  logInfo "FINISHED ${SCRIPT_NAME} $(date +%Y-%m-%d-%H-%M-%S), RUNTIME: ${RUNTIME}"
}
trap cleanup EXIT

function logInfo {
    echo "INFO: $1"
}

SCRIPT_NAME="${0##*/}"
logInfo "STARTING ${SCRIPT_NAME} $(date +%Y-%m-%d-%H-%M-%S)"
echo

#END