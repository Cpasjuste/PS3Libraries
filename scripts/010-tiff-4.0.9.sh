#!/bin/sh -e
# tiff-4.0.3.sh by Jon Limle <jonlimle123@yahoo.com> (Updated by Spork Schivago)

LIBTIFF="tiff-4.0.9"

## Download the source code.
wget --tries 5 --timeout 15 --continue \
  ftp://ftp.remotesensing.org/pub/libtiff/${LIBTIFF}.tar.gz \
  || wget --continue \
  http://download.osgeo.org/libtiff/${LIBTIFF}.tar.gz;

## Unpack the source code.
rm -Rf ${LIBTIFF} && tar -zxvf ${LIBTIFF}.tar.gz && cd ${LIBTIFF}

## Patch the source if a patch exists.
if [ -f ../../patches/${LIBTIFF}-PPU.patch ]; then
  echo "patching ${LIBTIFF}..."
  cat ../../patches/${LIBTIFF}-PPU.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CPPFLAGS="-I${PSL1GHT}/ppu/include -I${PS3DEV}/portlibs/ppu/include" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host="powerpc64-ps3-elf" --disable-shared --enable-option-checking

## Compile and install.
${MAKE:-make} && ${MAKE:-make} install
