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

# 阻止 ./autogen.sh 内直接运行 configure
export NOCONFIGURE=no-config
# -mno-ieee-fp is not supported by clang
sed s/\-mno\-ieee\-fp// -i configure.ac

unset CC CXX # meson wants these unset

CFLAGS=-fPIC CXXFLAGS=-fPIC meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
    --buildtype=release \
    --default-library=static \
	-Dfontconfig=disabled \
	-Dlibunibreak=enabled \
	-Dtest=disabled \
	-Dcompare=disabled \
	-Dprofile=disabled \
	-Dasm=disabled \
	-Dcheckasm=disabled \
	-Drequire-system-font-provider=false

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install
