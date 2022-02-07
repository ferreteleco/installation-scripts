#!/usr/bin/env bash
#
# This script is intended to install JSON for Modern C++ from source
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

JSON_VERSION=3.10.5

echo "---- JSON for Modern C++ Installation Script ----"

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
echo "1. Downloading JSON for Modern C++ v${JSON_VERSION}"

sudo -u $REAL_USER curl -o json-${JSON_VERSION}.tar.xz -L https://github.com/nlohmann/json/archive/v${JSON_VERSION}.tar.gz

sudo -u $REAL_USER tar xvf json-${JSON_VERSION}.tar.xz

cd json-${JSON_VERSION}

echo " "
echo " "
echo " "
echo "2. Building JSON for Modern C++ v${JSON_VERSION}"

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
echo "3. Installing JSON for Modern C++ v${JSON_VERSION}"

make install

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
