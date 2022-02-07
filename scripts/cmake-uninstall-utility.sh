#! /usr/bin/env bash
#
# This script is intended to uninstall any source installed software (CMake built),
# by providing the script with the path of the project.
# NOTE: file install_manifest.txt must be found in the /build directory of the
# builded project.
#
# Copyright (c) 2022 Andrés Ferreiro González
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


if ! [ $(id -u) = 0 ]; then
   echo "ERROR: The script need to be run as root." >&2
   exit -1
fi

if [[ $# -eq 0 ]];
then
  echo "ERROR: No argument provided, please specify a valid path to a CMake project"
  exit -1
fi

# Enable exit on error
set -e

input=$1
echo "Deleting all installed files specified in $input/build/install_manifest.txt"
echo ""
echo ""
if [[ -f "$input/build/install_manifest.txt" ]];then
  while IFS= read -r line
    do
      if [[ -f $line ]];then
        echo "Removing $line"
        rm -f "$line"
      fi
    done < "$input/build/install_manifest.txt"
fi
echo "Successfully uninstalled files under $input/build/install_manifest.txt"

echo ""
echo ""
echo "Removing repository"

rm -rf $input

echo ""
echo ""
echo "Successfully removed files under $input"

echo ""
echo ""
echo "Uninstall finished!"
echo ""
echo ""



