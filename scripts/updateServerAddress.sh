#!/bin/bash

my_dir="$(dirname "$0")"

# Include common functions
. ${my_dir}/util/common.sh

if [[ ${UPDATE_SERVER_ADDRESS} == false ]]; then
    logInfo "SKIPPING ${SCRIPT_NAME}"
    exit 0
fi

logInfo "STARTED updateServerAddress.sh"

PUBLIC_IP_ADDRESS_FILE=/tmp/PUBLIC_IP_ADDRESS.txt
PUBLIC_IP_ADDRESS=$(cat ${PUBLIC_IP_ADDRESS_FILE})

sed -i -e 's#$PUBLIC_IP_ADDRESS#'"${PUBLIC_IP_ADDRESS}"'#g' ../pages/index.js

#END