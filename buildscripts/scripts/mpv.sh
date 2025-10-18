#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

# Android provides Vulkan, but no pkgconfig file
# you can double-check the version in vk.xml (ctrl+f VK_API_VERSION)
# mkdir -p "$prefix_dir"/lib/pkgconfig
# cat >"$prefix_dir"/lib/pkgconfig/vulkan.pc <<"END"
# Name: Vulkan
# Description:
# Version: 1.3.0
# Libs: -lvulkan
# Cflags:
# END

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/
unset CC CXX # meson wants these unset

CFLAGS="-I$prefix_dir/include" CXXFLAGS="-I$prefix_dir/include" LDFLAGS="-L$prefix_dir/lib/ -liconv -lm -lc++" meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
	--prefer-static \
	--default-library shared \
    -Dbuildtype=release \
    -Db_lto=true \
	-Db_lto_mode=thin \
	-Ddebug=false \
	-Db_ndebug=true \
	-Doptimization=3 \
	-Dlibmpv=true \
 	-Dcplayer=false \
	-Dgpl=true \
	\
	-Dhtml-build=disabled \
	-Dmanpage-build=disabled \
	-Dpdf-build=disabled \
	\
	-Dcplugins=disabled \
	-Dlua=disabled \
	-Djavascript=disabled \
	\
	-Dlibbluray=disabled \
	-Ddvdnav=disabled \
	-Dvapoursynth=disabled \
	\
	-Duchardet=enabled \
	-Dlibarchive=enabled \
	-Drubberband=enabled \
	-Dlcms2=enabled \
	-Diconv=enabled \
	\
	-Dcaca=disabled \
	-Dsixel=disabled \
	-Dwayland=disabled \
	-Dx11=disabled \
	-Dalsa=disabled \
	-Dpulse=disabled \
    -Dopensles=enabled \
	-Dsdl2-audio=disabled \
	-Degl=disabled \
	-Degl-android=enabled \
	-Dgl=enabled \
	-Dplain-gl=enabled \
	-Dvulkan=disabled \
	-Dshaderc=disabled \
    -Dspirv-cross=disabled \
	-Dsdl2-video=disabled \
	\
	-Dandroid-media-ndk=enabled \


"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install

ln -sf "$prefix_dir"/lib/libmpv.so "$native_dir"

mpv_output_dir="$build_home_dir/output/libmpv/$ndk_triple"
mkdir -p $mpv_output_dir
[ -f "$prefix_dir/lib/libmpv.so" ] && cp -f "$prefix_dir"/lib/libmpv.so "$mpv_output_dir/"