#!/bin/bash

# Stops on first error, echo on
set -e
set -x

SRCDIR=$1
OUTDIR=$2

COMMON_OPTIONS="-DALLOW_NIGHTLY_BUILDS=YES -DVERSION_SUFFIX=$3 -DGVARS=YES -DHELI=YES"

if [ "$(uname)" = "Darwin" ]; then
    COMMON_OPTIONS="${COMMON_OPTIONS} -DCMAKE_PREFIX_PATH=~/Qt/5.7/clang_64/ -DCMAKE_OSX_DEPLOYMENT_TARGET='10.9'"
fi

STM32_OPTIONS="${COMMON_OPTIONS} -DLUA=YES"

if [ "$3" == "" ]; then
   echo "Usage $0 SRCDIR OUTDIR VERSION_SUFFIX"
   exit 1
fi


rm -rf build
mkdir build
cd build

cmake ${COMMON_OPTIONS} -DPCB=9X ${SRCDIR}
make -j2 libsimulator

cmake ${COMMON_OPTIONS} -DPCB=GRUVIN9X ${SRCDIR}
make -j2 libsimulator

cmake ${COMMON_OPTIONS} -DPCB=MEGA2560 ${SRCDIR}
make -j2 libsimulator

cmake ${COMMON_OPTIONS} -DPCB=SKY9X ${SRCDIR}
make -j2 libsimulator

cmake ${COMMON_OPTIONS} -DPCB=9XRPRO ${SRCDIR}
make -j2 libsimulator

cmake -DALLOW_NIGHTLY_BUILDS=YES -DVERSION_SUFFIX=$3 -DGVARS=NO -DHELI=YES -DPCB=X7D ${SRCDIR}
make -j2 libsimulator
 
cmake ${STM32_OPTIONS} -DPCB=X9D ${SRCDIR}
make -j2 libsimulator

cmake ${STM32_OPTIONS} -DPCB=X9D+ ${SRCDIR}
make -j2 libsimulator

cmake ${STM32_OPTIONS} -DPCB=X9E ${SRCDIR}
make -j2 libsimulator

cmake ${STM32_OPTIONS} -DPCB=HORUS ${SRCDIR}
make -j2 libsimulator

make -j2 package

if [ "$(uname)" = "Darwin" ]; then
    cp *.dmg ${OUTDIR}
else
    cp *.deb ${OUTDIR}
fi
