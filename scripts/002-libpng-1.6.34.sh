#!/bin/sh -e
# libpng-1.6.34.sh by Dan Peori (danpeori@oopo.net) (updated by Spork Schivago)

LIBPNG_VER="1.6.34"
LIBPNG="libpng-${LIBPNG_VER}"
ZLIBLIB="${PS3DEV}/portlibs/ppu/lib" export ZLIBLIB
ZLIBINC="${PS3DEV}/portlibs/ppu/include" export ZLIBINC
CPPFLAGS="-I${ZLIBINC} -I${PS3DEV}/portlibs/ppu/include" export CPPFLAGS
LDFLAGS="-L${ZLIBLIB} -L${PS3DEV}/portlibs/ppu/lib" export LDFLAGS
# LDFLAGS="-L${ZLIBLIB} -L${PS3DEV}/portlibs/ppu/lib -lrt -llv2" export LDFLAGS
LD_LIBRARY_PATH="${ZLIBLIB}:$LD_LIBRARY_PATH" export LD_LIBRARY_PATH
PKG_CONFIG_PATH="${PS3DEV}/portlibs/ppu" export PKG_CONFIG_PATH

## Download the source code.
wget --continue --max-redirect=100 "http://sourceforge.net/projects/libpng/files/libpng16/${LIBPNG_VER}/${LIBPNG}.tar.xz" || wget --continue --max-redirect=100 "http://sourceforge.net/projects/libpng/files/libpng16/older-releases/${LIBPNG_VER}/${LIBPNG}.tar.xz"

## Unpack the source code.
rm -Rf ${LIBPNG} && tar -xvJf ${LIBPNG}.tar.xz && cd ${LIBPNG}

## Patch the source if a patch exists.
if [ -f ../../patches/${LIBPNG}-PPU.patch ]; then
  echo "patching ${LIBPNG}..."
  cat ../../patches/${LIBPNG}-PPU.patch | patch -p1;
fi

## Create the build directory.
mkdir build-ppu && cd build-ppu

## Configure the build.
../configure --prefix="${PS3DEV}/portlibs/ppu" --host="powerpc64-ps3-elf" \
	--enable-static --disable-shared --with-pkgconfigdir="${PS3DEV}/portlibs/ppu/lib/pkgconfig" \
	--with-zlib-prefix="${PS3DEV}/portlibs/ppu"

## Compile and install.
${MAKE:-make} -j4 && ${MAKE:-make} install
