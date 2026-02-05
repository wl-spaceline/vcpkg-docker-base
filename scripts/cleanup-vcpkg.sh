#!/bin/bash

# To keep ONLY Release builds and not Debug symbols,delete the debug folder (saves ~50% of the installed size):
# rm -rf ${VCPKG_ROOT}/installed/x64-linux/debug
rm -rf ${VCPKG_ROOT}/buildtrees && rm -rf ${VCPKG_ROOT}/downloads && rm -rf ${VCPKG_ROOT}/packages