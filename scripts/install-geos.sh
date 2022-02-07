#!/usr/bin/env bash
#
# This script is intended to install GEOS from source
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

GEOS_VERSION=3.10.2

echo "---- GEOS Installation Script ----"

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
echo "1. Downloading GEOS v${GEOS_VERSION}"

sudo -u $REAL_USER curl -o geos-${GEOS_VERSION}.tar.xz -L https://github.com/libgeos/geos/archive/refs/tags/${GEOS_VERSION}.tar.gz

sudo -u $REAL_USER tar xvf geos-${GEOS_VERSION}.tar.xz

cd geos-${GEOS_VERSION}

echo " "
echo " "
echo " "
echo "2. Building GEOS v${GEOS_VERSION}"

sudo -u $REAL_USER mkdir build

cd build
sudo -u $REAL_USER cmake .. -DCMAKE_BUILD_TYPE=Release

np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")

sudo -u $REAL_USER make -j ${jobs}

echo " "
echo " "
echo " "
echo "3. Installing GEOS v${GEOS_VERSION}"

make install

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
