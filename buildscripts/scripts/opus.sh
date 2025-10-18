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

cp -f ../opus_dnn/*.h ../opus_dnn/*.c dnn/

# 阻止 ./autogen.sh 内直接运行 configure
export NOCONFIGURE=no-config
# -mno-ieee-fp is not supported by clang
sed s/\-mno\-ieee\-fp// -i configure.ac
[ -f configure ] || ./autogen.sh

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

../configure \
	--host=$ndk_triple \
    --disable-hardening \
    --disable-doc \
    --disable-extra-programs \

# opus 有asm，需要特定指定特定编译平台的汇编器
make -j$cores
make DESTDIR="$prefix_dir" install
