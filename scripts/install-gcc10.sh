#!/usr/bin/env bash
#
# This script is intended to install GCC/G++ 10
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

if ! [ $(id -u) = 0 ]; then
    echo "The script need to be run as root." >&2
    exit 1
fi

apt-get install -y -qq gcc-10 g++-10
