#! /usr/bin/env bash
#
# This script is intended to install pybind11 utility library
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

PYBIND11_JSON_VERSION=0.2.12
echo "---- pybind11 json 4 modern C++ bindings v${PYBIND11_JSON_VERSION} Installation Script ----"

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
echo "1. Downloading pybind11-json 4 modern C++ bindings v${PYBIND11_JSON_VERSION}"

sudo -u $REAL_USER curl -o pybind11_json-${PYBIND11_JSON_VERSION}.tar.gz -L https://github.com/pybind/pybind11_json/archive/refs/tags/${PYBIND11_JSON_VERSION}.tar.gz
sudo -u $REAL_USER tar xvf pybind11_json-${PYBIND11_JSON_VERSION}.tar.gz

cd pybind11_json-${PYBIND11_JSON_VERSION}

echo " "
echo " "
echo " "
echo "2. Building pybind11-json 4 modern C++ bindings v${PYBIND11_JSON_VERSION}"

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
echo "3. Installing pybind11-json 4 modern C++ bindings v${PYBIND11_JSON_VERSION}"

make install

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
