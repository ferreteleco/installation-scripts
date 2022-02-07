#! /usr/bin/env bash
#
# This script is intended to install Catch2 from source
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

CATCH2=3.0.0-preview3

echo "---- Catch2 v${CATCH2} Installation Script ----"

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
echo "1. Downloading Catch2 v${CATCH2}"

sudo -u $REAL_USER curl -o Catch2-${CATCH2}.tar.xz -L https://github.com/catchorg/Catch2/archive/v${CATCH2}.tar.gz
sudo -u $REAL_USER tar xvf Catch2-${CATCH2}.tar.xz

cd Catch2-${CATCH2}

echo " "
echo " "
echo " "
echo "2. Building Catch2 v${CATCH2}"

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
echo "3. Installing Catch2 v${CATCH2}"

make install

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
