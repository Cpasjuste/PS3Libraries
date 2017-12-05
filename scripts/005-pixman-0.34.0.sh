#!/bin/sh -e
# pixman-0.34.0.sh by Dan Peori (danpeori@oopo.net) (Updated by Spork Schivago)

PIXMAN="pixman-0.34.0"

## Download the source code.
wget --continue http://cairographics.org/releases/${PIXMAN}.tar.gz;

## Unpack the source code.
rm -Rf ${PIXMAN} && tar -zxvf ${PIXMAN}.tar.gz && cd ${PIXMAN}

## Patch the source if a patch exists.
if [ -f ../../patches/${PIXMAN}-PPU.patch ]; then
  echo "patching ${PIXMAN}..."
  cat ../../patches/${PIXMAN}-PPU.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
CFLAGS="-DPIXMAN_NO_TLS" \
CPPFLAGS="-I${PSL1GHT}/ppu/include -I${PS3DEV}/portlibs/ppu/include" \
LDFLAGS="-L${PSL1GHT}/ppu/lib -L${PS3DEV}/portlibs/ppu/lib" \
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
../configure --prefix="${PS3DEV}/portlibs/ppu" --host="powerpc64-ps3-elf" --disable-shared --disable-vmx

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
