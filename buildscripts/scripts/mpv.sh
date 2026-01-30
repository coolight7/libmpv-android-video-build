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

export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/
unset CC CXX # meson wants these unset

# 清理标准库依赖
sed -i '/^Libs/ s|-lstdc++| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++_static| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++abi| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++_shared| |' $prefix_dir/lib/pkgconfig/*.pc
sed -i '/^Libs/ s|-lc++| |' $prefix_dir/lib/pkgconfig/*.pc

# 可用于限制导出的符号
# CFLAGS、CXXFLAGS 中添加  -fvisibility=hidden
# -Wl,--undefined-version,--version-script=$mpv_EXPORT_IDS
mpv_EXPORT_IDS=$build_home_dir/buildscripts/mpv-export.lds

# c++std: libjxl、shaderc
# 由 mediaxx 静态链接标准库并导出符号，libmpv 动态链接使用
CFLAGS="$CFLAGS -I$prefix_dir/include" CXXFLAGS="$CXXFLAGS -I$prefix_dir/include" LDFLAGS="$LDFLAGS -L$prefix_dir/lib/ $default_ld_cxx_stdlib -lm" meson setup $build \
	--cross-file "$prefix_dir"/crossfile.txt \
	--default-library static \
    -Dbuildtype=release \
    -Db_lto=true \
	-Db_lto_mode=default \
	-Db_ndebug=true \
	-Ddebug=false \
	-Doptimization=3 \
	-Dlibmpv=true \
 	-Dcplayer=false \
	-Dgpl=false \
    -Dbuild-date=false \
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
	-Diconv=enabled \
	-Dlibarchive=enabled \
	-Drubberband=enabled \
	-Dlcms2=enabled \
	\
	-Dcaca=disabled \
	-Dsixel=disabled \
	-Dwayland=disabled \
	-Dx11=disabled \
	-Dalsa=disabled \
	-Dpulse=disabled \
	-Dsdl2-audio=disabled \
	-Dsdl2-video=disabled \
	-Degl=disabled \
	-Dplain-gl=disabled \
    -Dopensles=enabled \
	-Degl-android=enabled \
	-Dgl=enabled \
	-Dvulkan=disabled \
	\
	-Dandroid-media-ndk=enabled \


"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install

ln -sf "$prefix_dir"/lib/libmpv.so "$native_dir"
