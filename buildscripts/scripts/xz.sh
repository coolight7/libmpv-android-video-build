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

autoreconf -fi

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

# apt install po4a

../configure \
	--host=$ndk_triple \
    --disable-shared \
    --enable-static \
    --with-pic \
    --disable-xz \
    --disable-xzdec \
    --disable-lzmadec \
    --disable-lzmainfo \
    --disable-doc \


make -j$cores
make DESTDIR="$prefix_dir" install
