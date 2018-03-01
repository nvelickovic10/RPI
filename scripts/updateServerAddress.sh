#!/bin/bash

# Change dir to script dir
cd "$(dirname "$0")"

# Include common functions
. common.sh

if [[ ${UPDATE_SERVER_ADDRESS} == false ]]; then
    logInfo "SKIPPING updateServerAddress.sh"
    exit 0
fi

logInfo "STARTED updateServerAddress.sh"

PUBLIC_IP_ADDRESS_FILE=./PUBLIC_IP_ADDRESS
PUBLIC_IP_ADDRESS=$(cat ${PUBLIC_IP_ADDRESS_FILE})

sed -i -e 's#$PUBLIC_IP_ADDRESS#'"${PUBLIC_IP_ADDRESS}"'#g' ../pages/index.js

logInfo "FINISHED updateServerAddress.sh"
#END