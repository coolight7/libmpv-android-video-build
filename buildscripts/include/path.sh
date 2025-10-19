#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

os=linux
[[ "$OSTYPE" == "darwin"* ]] && os=mac
export os

if [ "$os" == "mac" ]; then
	[ -z "$cores" ] && cores=$(sysctl -n hw.ncpu)
	# various things rely on GNU behaviour
	export INSTALL=`which ginstall`
	export SED=gsed
else
	[ -z "$cores" ] && cores=$(grep -c ^processor /proc/cpuinfo)
fi
cores=${cores:-4}

# configure pkg-config paths if inside buildscripts
# 搜索重定向根目录，因此 库写入 .pc 文件时路径应该保持原本的 /lib 一类的默认目录，不写入实际路径
# 而指定 install 目录安装到正确的路径
if [ -n "$ndk_triple" ]; then
	export PKG_CONFIG_SYSROOT_DIR="$prefix_dir"
	export PKG_CONFIG_LIBDIR="$PKG_CONFIG_SYSROOT_DIR/lib/pkgconfig"
	unset PKG_CONFIG_PATH
fi

toolchain=$(echo "$DIR/sdk/android-sdk-linux/ndk/$v_ndk/toolchains/llvm/prebuilt/"*)
export ANDROID_HOME="$DIR/sdk/android-sdk-$os"

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export NDK_PREFIX_DIR=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

export PATH="$toolchain/bin:$DIR/sdk/android-sdk-linux/ndk/$v_ndk:$DIR/sdk/bin:$MY_CMAKE_EXE_DIR:$PATH"
unset ANDROID_SDK_ROOT ANDROID_NDK_ROOT
