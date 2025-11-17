#!/bin/bash -e

cd src

. ../../../include/depinfo.sh
. ../../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

# 当只需要重新构建 mediaxx ，避免重复构建ffmpeg时启用
pushd $PWD
(. ../../../include/backup_restore_dll.sh $prefix_dir/lib/) || true
popd

build=_build$ndk_suffix

mkdir -p $build
cd $build

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

# 清理标准库依赖
sed -i '/^Libs/ s|-lstdc++| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++_static| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++abi| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++_shared| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++| |' $prefix_dir/lib/pkgconfig/*.pc

# 共享符号，编译 mediaxx 时开启导出全部符号，并让 mpv 尽量动态链接
# mediaxx: EXPORT_ALL_SYMBOL=ON
# mpv: --prefer-static

cpu=
[[ "$ndk_triple" == "aarch64"* ]] && cpu=aarch64
[[ "$ndk_triple" == "x86_64"* ]] && cpu=x86_64
[[ "$ndk_triple" == "i686"* ]] && cpu=x86

LDFLAGS="$LDFLAGS -L$prefix_dir/lib/ $default_ld_cxx_stdlib_mediaxx -lm -flto" CFLAGS="$CFLAGS -O3 -flto" CXXFLAGS="$CXXFLAGS -O3 -flto" "${MY_CMAKE_EXE_DIR}/cmake" -S.. -B. \
    -G Ninja \
    -DANDROID=ON \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_ANDROID_ARCH_ABI=$current_abi_name \
    -DANDROID_ABI=$current_abi_name \
    -DANDROID_PLATFORM=android-$v_min_sdk \
    -DANDROID_NDK=${ANDROID_NDK} \
    -DANDROID_STL=${default_cxx_stl} \
    -DTARGET_ARCHITECTURE=${cpu} \
    -DCMAKE_C_FLAGS="-I$prefix_dir/include -Wno-error=int-conversion -Wno-error=incompatible-function-pointer-types ${cpuflags}" \
    -DCMAKE_CXX_FLAGS="-I$prefix_dir/include" \
    -DCMAKE_SHARED_LINKER_FLAGS="-L$prefix_dir/lib/ $default_ld_cxx_stdlib_mediaxx -lm" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_FIND_ROOT_PATH=${prefix_dir} \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DEXPORT_ALL_SYMBOL=OFF \
    -DSTATIC_LINK_FFMPEG=ON \
    -DSTATIC_LINK_LIBMPV=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_STATIC=OFF \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \


"${MY_CMAKE_EXE_DIR}/ninja" -C .
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C . install

(. ../../../../include/backup_dll.sh $prefix_dir/lib/) || true

libdir_stdcxx=$prefix_dir/lib/stdcxx/
mkdir -p $libdir_stdcxx
cp $NDK_PREFIX_GROBAL_DIR/libc++_shared.so $libdir_stdcxx/