#!/bin/bash

sudo apt update && sudo apt install pkg-config-riscv64-linux-gnu

conda env create -f keystone-reqs.yml
