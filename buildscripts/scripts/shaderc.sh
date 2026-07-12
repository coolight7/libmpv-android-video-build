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

cpu=
[[ "$ndk_triple" == "aarch64"* ]] && cpu=aarch64
[[ "$ndk_triple" == "x86_64"* ]] && cpu=x86_64
[[ "$ndk_triple" == "i686"* ]] && cpu=x86

LTO_JOB=1 CONF=1 "${MY_CMAKE_EXE_DIR}/cmake" -S.. -B. \
    -G Ninja \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DCMAKE_ANDROID_ARCH_ABI=$current_abi_name \
    -DANDROID_ABI=$current_abi_name \
    -DANDROID_PLATFORM=android-$v_min_sdk \
    -DTARGET_ARCHITECTURE=${cpu} \
    -DCMAKE_C_FLAGS=-fPIC \
	-DCMAKE_CXX_FLAGS="-fPIC -std=c++17" \
    -DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr/local/ \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_FIND_ROOT_PATH=${prefix_dir} \
    -DBUILD_SHARED_LIBS=OFF \
	-DSHADERC_SKIP_TESTS=ON \
	-DSHADERC_SKIP_SPVC=ON \
	-DSHADERC_SKIP_INSTALL=ON \
	-DSHADERC_SKIP_EXAMPLES=ON \
	-DSPIRV_SKIP_EXECUTABLES=ON \
	-DSPIRV_SKIP_TESTS=ON \
	-DENABLE_SPIRV_TOOLS_INSTALL=ON \
	-DENABLE_GLSLANG_BINARIES=OFF \
	-DSPIRV_TOOLS_BUILD_STATIC=ON \
	-DSPIRV_TOOLS_LIBRARY_TYPE=STATIC \

# ninja: Entering directory `.' 编译时日志可能会在这卡一会，耐心等
LTO_JOB=1 "${MY_CMAKE_EXE_DIR}/ninja" -C .
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C . install

cp -f -r "../libshaderc/include/shaderc" "$prefix_dir/include/shaderc"
cp -f "./libshaderc/libshaderc_combined.a" "$prefix_dir/lib/libshaderc_combined.a"
cp -f "./shaderc_combined.pc" "$prefix_dir/lib/pkgconfig/shaderc_combined.pc"
cp -f "./shaderc_combined.pc" "$prefix_dir/lib/pkgconfig/shaderc.pc"

sed '/^Libs:/ s|$| -lc++_shared|' "$prefix_dir/lib/pkgconfig/shaderc.pc" -i
sed '/^Libs:/ s|$| -lc++_shared|' "$prefix_dir/lib/pkgconfig/shaderc_combined.pc" -i