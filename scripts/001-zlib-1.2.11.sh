#!/bin/sh -e
# zlib-1.2.11.sh by Dan Peori (danpeori@oopo.net) (Updated by Spork Schivago)

ZLIB="zlib-1.2.11"

## Download the source code.
wget --continue http://zlib.net/${ZLIB}.tar.gz

## Unpack the source code.
rm -Rf ${ZLIB} && tar -xvzf ${ZLIB}.tar.gz && cd ${ZLIB}

## Patch the source code if a patch exists.
if [ -f ../../patches/${ZLIB}-PPU.patch ]; then
  echo "patching ${ZLIB}..."
  cat ../../patches/${ZLIB}-PPU.patch | patch -p1;
fi

## Configure the build.
AR="powerpc64-ps3-elf-ar" \
CC="powerpc64-ps3-elf-gcc" \
RANLIB="powerpc64-ps3-elf-ranlib" \
./configure --prefix="${PS3DEV}/portlibs/ppu" --static

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
