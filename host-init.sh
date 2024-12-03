#!/bin/sh

set -e

if [ $(command -v cmake3) ]; then
	echo "Using cmake3"
	alias cmake=cmake3
fi

if [ ! -d keystone ]; then
	git clone https://github.com/keystone-enclave/keystone keystone
fi

# set qemu -bios argument to bootrom.bin we will build
PWD=$(pwd)
sed -e 's#\-bios .*bootrom.bin#\-bios '$PWD'/keystone/build/bootrom.build/bootrom.bin#g' -i keystone.json

cd keystone
git checkout dev

if ! grep -Fq "cstdint" sdk/include/host/keystone_user.h; then
	sed -i '10i\#include <cstdint>' sdk/include/host/keystone_user.h
fi
sed -i '92c\    CONFIGURE_COMMAND sed -i "10s/-g/-g -march=rv64gc_zifencei/" Makefile' sdk/macros.cmake

./fast-setup.sh
if [[ -z "${KEYSTONE_SDK_DIR}" ]]; then
	source ./source.sh
fi
mkdir -p build
cd build
cmake .. -Dfiresim=y
make patch
make bootrom
#make qemu
make examples

