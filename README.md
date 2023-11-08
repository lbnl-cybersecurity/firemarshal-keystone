# FireMarshal Keystone on FireSim

FireSim Version: [`v1.16.0`](https://github.com/firesim/firesim/releases/tag/1.16.0)

This repository contains changes from the original [firemarhsal-keystone](https://github.com/keystone-enclave/firemarshal-keystone) repository. This uses the `dev` banch of the [Keystone](https://github.com/keystone-enclave/keystone/tree/dev) repository.

This build was tested using [**B**erkeley e**X**tensible **E**nvironment (BXE)](https://socks.lbl.gov/cag/bxe/-/wikis/home). This can be run both on the virtual machines as well as the [BXE Docker image](https://socks.lbl.gov/cag/bxe/-/wikis/Docker-Image).

- [FireMarshal Keystone on FireSim](#firemarshal-keystone-on-firesim)
  - [Running BXE Docker Keystone Image](#running-bxe-docker-keystone-image)
  - [Prerequisites for Building Keystone](#prerequisites-for-building-keystone)
  - [Building Keystone for FireMarshal on BXE VMs](#building-keystone-for-firemarshal-on-bxe-vms)
  - [Building Keystone for FireMarshal on BXE Docker](#building-keystone-for-firemarshal-on-bxe-docker)

## Running BXE Docker Keystone Image

1. Pull the Keystone BXE Docker image

```bash
docker pull socks.lbl.gov:4567/cag/bxe:keystone
```

2. Run the Docker image

```bash
docker run --privileged -it socks.lbl.gov:4567/cag/bxe:keystone
```

3. Source FireSim

```bash
source source-env.sh
```

4. Launch Keystone with FireMarshal

```bash
cd ~/firesim/sw/firesim-software
./marshal -v launch bxe-workloads/firemarshal-keystone/keystone.json
```

## Prerequisites for Building Keystone
- Install the prerequisites for Keystone to build

```bash
sudo apt install cmake makeself ninja-build pkg-config pkg-config-riscv64-linux-gnu libglib2.0-dev
```

## Building Keystone for FireMarshal on BXE VMs

**NOTE:** Make sure you've installed [prerequisites](#prerequisites) in your BXE VM.

1. Source FireSim

```bash
cd firesim
source sourceme-f1-manager.sh --skip-ssh-setup
```

2. Clone this repository into the FireMarshal directory.

```bash
cd ~/firesim/sw/firesim-software
mkdir bxe-workloads
cd bxe-workloads
git clone https://github.com/lbnl-cybersecurity/firemarshal-keystone.git
cd ..
```

3. Source the `source-keystone.sh` script. This will modify `PATH` to make sure the system `cmake` has priority over Xilinx's older version of `cmake`.

```bash
source bxe-workloads/firemarshal-keystone/source-bxevm-keystone.sh
```

4. Run a FireMarshal build. This will _FAIL_ the first time, as `KEYSTONE_SDK_DIR` isn't set your enivironment. However, this will pull the `keystone` project from GitHub and do some preliminary set up.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

5. Source the newly generated Keystone sourcing script to add `KEYSTONE_SDK_DIR` to you environment.

```bash
source bxe-workloads/firemarshal-keystone/keystone/source.sh
```

6. Rerun the FireMarshal build. This will _FAIL_ again as the `tests.ke` file is missing for Keystone.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

7. Navigate to the Keystone build directory and run `make examples` to build the required `tests.ke` file. This make will ultimately fail, as we haven't set up attestation, but the `tests.ke` file is generated.

```bash
cd bxe-workloads/firemarshal-keystone/keystone/build
make examples
cd ../../../..
```

8. Rerun the FireMarshal build. This should run without any errors and generate the disk image.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

9. Run the FireMarshal simulation to verify the build.

```bash
./marshal -v launch bxe-workloads/firemarshal-keystone/keystone.json
```

10. Once confirmed, install the workload to FireSim to prepare for an FPGA simulation. Follow the instructions on running a [Hardware FPGA Simulation on BXE](https://socks.lbl.gov/cag/bxe/-/wikis/home#launching-the-default-firesim-simulation-on-your-fpga).

```bash
./marshal -v install bxe-workloads/firemarshal-keystone/keystone.json
```

## Building Keystone for FireMarshal on BXE Docker

**NOTE:** Make sure you've installed [prerequisites](#prerequisites) in the Docker container.

1. Source FireSim

```bash
source source-env.sh
```

2. Clone this repository into the FireMarshal directory.

```bash
cd ~/firesim/sw/firesim-software
mkdir bxe-workloads
cd bxe-workloads
git clone https://github.com/lbnl-cybersecurity/firemarshal-keystone.git
cd ..
```

3. Run a FireMarshal build. This will fail the first time, as `KEYSTONE_SDK_DIR` isn't set your enivironment. However, this will pull the `keystone` project from GitHub and do some preliminary set up.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

4. Source the newly generated Keystone sourcing script to add `KEYSTONE_SDK_DIR` to you environment.

```bash
source bxe-workloads/firemarshal-keystone/keystone/source.sh
```

5. Rerun the FireMarshal build. This will _FAIL_ again as the `tests.ke` file is missing for Keystone.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

6. Navigate to the Keystone build directory and run `make examples` to build the required `tests.ke` file. This make will ultimately fail, as we haven't set up attestation, but the `tests.ke` file is generated.

```bash
cd bxe-workloads/firemarshal-keystone/keystone/build
make examples
cd ../../../..
```

7. Rerun the FireMarshal build. This should run without any errors and generate the disk image.

```bash
./marshal -v build bxe-workloads/firemarshal-keystone/keystone.json
```

8. Run the FireMarshal simulation to verify the build.

```bash
./marshal -v launch bxe-workloads/firemarshal-keystone/keystone.json
```
