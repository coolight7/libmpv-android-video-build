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

unset CC CXX # meson wants these unset

meson setup $build ./build/meson --cross-file "$prefix_dir"/crossfile.txt \
    --buildtype=release \
    --default-library=static \
    -Dlegacy_level=0 \
    -Ddebug_level=0 \
    -Dbin_programs=false \
    -Dzlib=disabled \
    -Dlzma=disabled \
    -Dlz4=disabled \


export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install
