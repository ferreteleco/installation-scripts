#! /usr/bin/env bash
#
# This script is intended to install SPDLOG logging library
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

SPDLOG=1.9.2
echo "---- SPDLOG v${SPDLOG} Installation Script ----"
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
echo "1. Downloading SPDLOG v${SPDLOG}"
sudo -u $REAL_USER curl -o spdlog-${SPDLOG}.tar.gz -L https://codeload.github.com/gabime/spdlog/tar.gz/v${SPDLOG}
sudo -u $REAL_USER tar xvf spdlog-${SPDLOG}.tar.gz
cd spdlog-${SPDLOG}
echo " "
echo " "
echo " "
echo "2. Building SPDLOG v${SPDLOG}"
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
echo "3. Installing SPDLOG v${SPDLOG}"
make install
ldconfig
echo " "
echo " "
echo " "
echo "Installation complete"
