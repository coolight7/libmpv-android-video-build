#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

# 阻止 ./autogen.sh 内直接运行 configure
export NOCONFIGURE=no-config
[ -f configure ] || ./autogen.sh

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

CONF=1 ../configure \
	CFLAGS=-fPIC CXXFLAGS=-fPIC \
	--host=$ndk_triple \
    --enable-static \
    --disable-shared \
    --disable-nls \
    --enable-extra-encodings \

make -j$cores
make DESTDIR="$prefix_dir" install

cat >"$prefix_dir"/lib/pkgconfig/iconv.pc <<END
prefix=/usr/local
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${prefix}/lib

Name: iconv
Description: A collection of tools, libraries, and tests for Vulkan shader compilation.
Version: 1.18
Libs: -L\${libdir} -liconv
Cflags: -I\${includedir}
END


cat >"$prefix_dir"/lib/pkgconfig/libiconv.pc <<END
prefix=/usr/local
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${prefix}/lib

Name: libiconv
Description: A collection of tools, libraries, and tests for Vulkan shader compilation.
Version: 1.18
Libs: -L\${libdir} -liconv
Cflags: -I\${includedir}
END