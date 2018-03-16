#!/bin/bash

# Change dir to script dir
cd "$(dirname "$0")"

# Include common functions
. common.sh

SCRIPT_NAME="${0##*/}"

logInfo "STARTING ${SCRIPT_NAME}"

PUBLIC_IP_ADDRESS_FILE="/tmp/PUBLIC_IP_ADDRESS.txt"

CURRENT_IP_ADDRESS=$(curl -s ipinfo.io/ip)

if [ ! -f  ${PUBLIC_IP_ADDRESS_FILE} ]; then
    logInfo "First time check"
    PUBLIC_IP_ADDRESS=""
else
    PUBLIC_IP_ADDRESS=$(cat ${PUBLIC_IP_ADDRESS_FILE})
fi

logInfo "OLD: $PUBLIC_IP_ADDRESS"
logInfo "NEW: $CURRENT_IP_ADDRESS"

if [[ ${CURRENT_IP_ADDRESS} == ${PUBLIC_IP_ADDRESS} ]]; then
    logInfo "IP address did not change"
else
    logInfo "IP address changed!!"
    echo ${CURRENT_IP_ADDRESS} > ${PUBLIC_IP_ADDRESS_FILE}
    mpack -s "Internet connection checker" ${PUBLIC_IP_ADDRESS_FILE} nvelickovic10@gmail.com
fi

logInfo "FINISHED ${SCRIPT_NAME}"
#END