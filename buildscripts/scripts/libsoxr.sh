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

if [ -f "$prefix_dir/lib/libsoxr.a" ]; then
    exit 0
fi

build=_build$ndk_suffix

mkdir -p $build
cd $build

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

# 如果提前编译出了 libav*，编译时会启用依赖 AV_FFT ，然后导致编译 ffmpeg 时循环依赖错误，需要删除 .a 
if [ -f "$prefix_dir/lib/libavcodec.a" ]; then
    echo "!!! 不应存在 libavcodec.a: $prefix_dir/lib/libavcodec.a !!!"
    exit -1
fi

# cmake 可能会在配置后调用 ninja -C build -t recompact
# 可执行文件 ninja 可能不同，可以在 PATH 中配置提高优先级 $MY_CMAKE_EXE_DIR/（已在 ../../include/path.sh 中）
CONF=1 "${MY_CMAKE_EXE_DIR}/cmake" -S.. -B. \
    -G Ninja \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_ANDROID_ARCH_ABI=$current_abi_name \
    -DANDROID_PLATFORM=android-$v_min_sdk \
    -DDCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_FIND_ROOT_PATH=${prefix_dir} \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_LSR_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DWITH_AVFFT=OFF \
    -DWITH_OPENMP=OFF \
    -DHAVE_WORDS_BIGENDIAN_EXITCODE=1 \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5


"${MY_CMAKE_EXE_DIR}/ninja" -C .
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C . install

cat >"$prefix_dir"/lib/pkgconfig/soxr.pc <<END
prefix=/usr/local
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${prefix}/lib

Name: soxr
Description: High quality, one-dimensional sample-rate conversion library
Version: 0.1.3
Libs: -L\${libdir} -lsoxr
Cflags: -I\${includedir}
END

cat >"$prefix_dir"/lib/pkgconfig/soxr-lsr.pc <<END
prefix=/usr/local
exec_prefix=\${prefix}
includedir=\${prefix}/include
libdir=\${prefix}/lib

Name: soxr-lsr
Description: High quality, one-dimensional sample-rate conversion library (with libsamplerate-like bindings)
Version: 0.1.3
Libs: -L\${libdir} -lsoxr-lsr
Cflags: -I\${includedir}
END