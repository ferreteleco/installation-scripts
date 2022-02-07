#!/usr/bin/env bash
#
# This script is intended to install PROJ library
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

PROJ_VERSION=8.2.1

echo "---- PROJ Installation Script ----"

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
apt-get install -y sqlite3 libtiff-dev libcurl4-openssl-dev libsqlite3-dev pkg-config

echo " "
echo " "
echo " "
echo "1. Downloading PROJ v${PROJ_VERSION}"

sudo -u $REAL_USER curl -o proj-${PROJ_VERSION}.tar.gz -L https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz
sudo -u $REAL_USER tar xvf proj-${PROJ_VERSION}.tar.gz

cd proj-${PROJ_VERSION}

echo " "
echo " "
echo " "
echo "2. Building PROJ v${PROJ_VERSION}"

./configure
np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")

make -j ${jobs}

echo " "
echo " "
echo " "
echo "3. Installing PROJ v${PROJ_VERSION}"

make install

echo " "
echo " "
echo " "
echo "4. Installing PROJ data"

ldconfig

projsync --system-directory --all

ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
