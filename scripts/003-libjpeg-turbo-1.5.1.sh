#!/bin/sh -e
# libjpeg-turbo by Cpasjuste

LIBJPEG_VER="1.5.1"
LIBJPEG="libjpeg-turbo-${LIBJPEG_VER}"
CPPFLAGS="-I${PS3DEV}/portlibs/ppu/include" export CPPFLAGS
LDFLAGS="-L${PS3DEV}/portlibs/ppu/lib" export LDFLAGS
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu" export PKG_CONFIG_PATH

## Download the source code.
wget --continue --max-redirect=100 "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_VER}.tar.gz"

## Unpack the source code.
rm -Rf ${LIBJPEG} && tar -zxvf ${LIBJPEG_VER}.tar.gz && cd ${LIBJPEG}

## ...
autoreconf -fiv

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
../configure --prefix="${PS3DEV}/portlibs/ppu" --host="powerpc64-ps3-elf" \
	--disable-shared --enable-static --without-simd --without-turbojpeg

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
