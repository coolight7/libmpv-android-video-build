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

# c++std: libjxl、shaderc
# 链接c++标准库时，需要静态链接
CFLAGS="-I$prefix_dir/include " CXXFLAGS="-I$prefix_dir/include " LDFLAGS="-L$prefix_dir/lib/ -liconv -nostdlib++ -lc++_static -lc++abi" meson setup $build \
	--cross-file "$prefix_dir"/crossfile.txt \
	--prefer-static \
	--default-library shared \
    -Dbuildtype=release \
    -Db_lto=true \
	-Db_lto_mode=default \
	-Db_ndebug=true \
	-Ddebug=false \
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
	-Duchardet=disabled \
	-Dlibarchive=enabled \
	-Drubberband=enabled \
	-Dlcms2=enabled \
	-Diconv=disabled \
	\
	-Dcaca=disabled \
	-Dsixel=disabled \
	-Dwayland=disabled \
	-Dx11=disabled \
	-Dalsa=disabled \
	-Dpulse=disabled \
    -Dopensles=enabled \
	-Dsdl2-audio=disabled \
	-Dsdl2-video=disabled \
	-Degl=disabled \
	-Degl-android=enabled \
	-Dgl=enabled \
	-Dplain-gl=disabled \
	-Dvulkan=disabled \
	\
	-Dandroid-media-ndk=enabled \


"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install

ln -sf "$prefix_dir"/lib/libmpv.so "$native_dir"
