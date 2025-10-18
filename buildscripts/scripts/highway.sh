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

# 需要安装 gtest，但不用运行
# sudo apt install libgtest-dev
# cflags 中定义 HWY_TEST_STANDALONE=1 并删除 BUILD 文件中每一处 `gtest_main`
CFLAGS="-fPIC -DHWY_TEST_STANDALONE=1" CXXFLAGS=-fPIC meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
    --buildtype=release \
    --default-library=static \
    -Dcontrib=disabled \
    -Dexamples=disabled \
    -Dtests=disabled \


export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install
