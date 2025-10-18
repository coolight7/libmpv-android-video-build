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

build=_build$ndk_suffix

mkdir -p $build
cd $build

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

CONF=1 "${MY_CMAKE_EXE_DIR}/cmake" -S.. -B. \
    -G Ninja \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_ANDROID_ARCH_ABI=$current_abi_name \
    -DANDROID_PLATFORM=android-$v_min_sdk \
    -DDCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC \
    -DCMAKE_ASM_FLAGS=-fPIC \
    -DCMAKE_ASM_NASM_FLAGS="-f elf32 -DPIC" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_FIND_ROOT_PATH=${prefix_dir} \
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_STATIC=ON \
    -DENABLE_SHARED=OFF \
    -DWITH_TURBOJPEG=OFF \


"${MY_CMAKE_EXE_DIR}/ninja" -C .
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C . install
