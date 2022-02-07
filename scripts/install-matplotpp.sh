#! /usr/bin/env bash
#
# This script is intended to install Matplot++ from source
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

MTPP_VERSION=1.1.0

echo "---- Matplot++ v${MTPP_VERSION} Installation Script ----"

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
echo "0. Configuring keyboard layout"

# Avoid keyboard configuration since docker is non-interactive and will freeze image building
# process. Ref: https://hub.docker.com/r/kdeneon/all/dockerfile

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
echo keyboard-configuration keyboard-configuration/layout select 'English (US)' | debconf-set-selections
echo keyboard-configuration keyboard-configuration/layoutcode select 'us' | debconf-set-selections
echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

echo " "
echo "1. Installing dependencies"

apt-get install -y -qq --no-install-recommends gnuplot libpng-dev libjpeg-dev

echo " "
echo " "
echo " "
echo "2. Downloading Matplot++ v${MTPP_VERSION}"
sudo -u $REAL_USER curl -o matplotplusplus-${MTPP_VERSION}.tar.gz -L https://github.com/alandefreitas/matplotplusplus/archive/refs/tags/v${MTPP_VERSION}.tar.gz
sudo -u $REAL_USER tar xvf matplotplusplus-${MTPP_VERSION}.tar.gz
echo " "
echo " "
echo " "
echo "3. Building Matplot++ v${MTPP_VERSION}"
cd matplotplusplus-${MTPP_VERSION}
sudo -u $REAL_USER mkdir build
cd build
np=$(nproc)

jobs=$((np / 2))

jobs=$( (($jobs <= 1)) && echo "1" || echo "$jobs")
sudo -u $REAL_USER cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O2" -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF
sudo -u $REAL_USER cmake --build . --parallel ${jobs} --config Release
echo " "
echo " "
echo " "
echo "4. Installing Matplot++ v${MTPP_VERSION}"
cmake --install .
echo " "
echo " "
echo " "
echo "Matplot++ v${MTPP_VERSION} Installation Complete"
