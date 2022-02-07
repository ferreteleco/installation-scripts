#! /usr/bin/env bash
#
# This script is intended to install GDAL from source
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

GDAL_VERSION=3.4.1

echo "---- GDAL v${GDAL_VERSION} Installation Script ----"

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
apt-get install -y -qq libtiff-dev libgeotiff-dev libjpeg-dev libpng-dev expat sqlite3 libsqlite3-dev zlib1g-dev libcurl4-openssl-dev

echo " "
echo " "
echo " "
echo "1. Downloading GDAL v${GDAL_VERSION}"
sudo -u $REAL_USER curl -o gdal-${GDAL_VERSION}.tar.gz -L https://github.com/OSGeo/gdal/releases/download/v${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
sudo -u $REAL_USER tar xvf gdal-${GDAL_VERSION}.tar.gz

cd gdal-${GDAL_VERSION}

echo " "
echo " "
echo " "
echo "2. Building GDAL v${GDAL_VERSION}"

./configure --with-python=python3 --with-proj=/usr/local --enable-shared
make clean

np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")

make -j ${jobs}

echo " "
echo " "
echo " "
echo "3. Installing GDAL v${GDAL_VERSION}"

make install
ldconfig

echo " "
echo " "
echo " "
echo "Installation complete"
