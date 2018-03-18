#!/bin/bash

# Change dir to script dir
cd ${my_dir}

# Log end of script
set -e
function cleanup {
  echo
  logInfo "FINISHED ${SCRIPT_NAME} $(date +%Y-%m-%d-%H-%M-%S)"
}
trap cleanup EXIT

function logInfo {
    echo "INFO: $1"
}

SCRIPT_NAME="${0##*/}"
logInfo "STARTING ${SCRIPT_NAME} $(date +%Y-%m-%d-%H-%M-%S)"
echo

#END