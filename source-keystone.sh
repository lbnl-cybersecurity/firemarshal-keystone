#!/bin/bash

if [[ -z "${FIRESIM_SOURCED}" ]]; then
    echo "\$FIRESIM_SOURCED is not set!"
    echo "Make sure to source FireSim before proceeding with FireMarshal Keystone"
    exit 1
fi

conda activate keystone

export KEYSTONE_ROOT=${FIREMARSHAL_ROOT}/bxe-workloads/firemarshal-keystone/keystone
