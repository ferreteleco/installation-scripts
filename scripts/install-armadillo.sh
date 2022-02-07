#! /usr/bin/env bash
#
# This script is intended to install Armadillo library
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

ARMADILLO=10.8.2
echo "---- Armadillo v${ARMADILLO} Installation Script ----"

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
echo "1. Downloading ARMADILLO v${ARMADILLO}"
sudo -u $REAL_USER curl -o armadillo-${ARMADILLO}.tar.gz -L https://sourceforge.net/projects/arma/files/armadillo-${ARMADILLO}.tar.xz/download
sudo -u $REAL_USER tar xvf armadillo-${ARMADILLO}.tar.gz
cd armadillo-${ARMADILLO}
echo " "
echo " "
echo " "
echo "2. Building ARMADILLO v${ARMADILLO}"
./configure
np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")

sudo -u $REAL_USER make -j ${jobs}
echo " "
echo " "
echo " "
echo "3. Installing ARMADILLO v${ARMADILLO}"
make install
ldconfig
echo " "
echo " "
echo " "
echo "Installation complete"
