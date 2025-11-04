#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

sed -i "s/both_libraries/library/g" ./src/meson.build

# 阻止 ./autogen.sh 内直接运行 configure
export NOCONFIGURE=no-config
# -mno-ieee-fp is not supported by clang
sed s/\-mno\-ieee\-fp// -i configure.ac

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export NDK_HOME=$ANDROID_NDK
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

unset CC CXX # meson wants these unset

# 需要安装 sudo apt install -y autopoint gperf gettext
CFLAGS="-fPIC -D_GNU_SOURCE" CXXFLAGS="-fPIC -D_GNU_SOURCE" meson setup $build --cross-file "$prefix_dir"/crossfile.txt -Ddefault_library=static \
        --libdir=lib \
        --buildtype=release \
        -Ddoc=disabled \
        -Dtests=disabled \
        -Dtools=disabled 


"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install
