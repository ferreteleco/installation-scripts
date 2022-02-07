#! /usr/bin/env bash
#
# This script is intended to install pybind11 utility library
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

PYBIND11_VERSION=2.9.1
echo "---- pybind11 v${PYBIND11_VERSION} Installation Script ----"

if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

if [ $SUDO_USER ]; then
    REAL_USER=$SUDO_USER
else
    REAL_USER=$(whoami)
fi

# Enable exit on error
set -e

echo " "
echo " "
echo " "
echo "0. Installing prerequisites"

apt-get install -y -qq python3-dev python3-pip
pip3 install pytest

echo " "
echo " "
echo " "
echo "1. Downloading pybind11 v${PYBIND11_VERSION}"

sudo -u $REAL_USER curl -o pybind11-${PYBIND11_VERSION}.tar.gz -L https://codeload.github.com/pybind/pybind11/tar.gz/v${PYBIND11_VERSION}
sudo -u $REAL_USER tar xvf pybind11-${PYBIND11_VERSION}.tar.gz

cd pybind11-${PYBIND11_VERSION}

echo " "
echo " "
echo " "
echo "2. Building pybind11 v${PYBIND11_VERSION}"

sudo -u $REAL_USER mkdir build

cd build

sudo -u $REAL_USER cmake ..

np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")

sudo -u $REAL_USER make -j ${jobs}

echo " "
echo " "
echo " "
echo "3. Installing pybind11 v${PYBIND11_VERSION}"

make install

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
