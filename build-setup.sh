#!/bin/bash

sudo apt update && sudo apt install pkg-config-riscv64-linux-gnu

conda env create -f conda-reqs/keystone.yml

git config --global http.version HTTP/1.1
git config --global http.postBuffer 524288000
git config --global core.compression 0
