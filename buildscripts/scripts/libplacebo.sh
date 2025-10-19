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

unset CC CXX
CFLAGS=-fPIC CXXFLAGS="-fPIC -I$prefix_dir/" meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
        --default-library=static \
        -Dshaderc=enabled \
        -Dopengl=enabled \
        -Dvulkan=enabled \
        -Dvk-proc-addr=enabled \
        -Dlcms=enabled \
        -Ddebug=false \
        -Db_ndebug=true \
        -Doptimization=3 \
        -Ddemos=false \
        -Dtests=false \


export ANDROID_NDK=$ANDROID_HOME/ndk/${v_ndk}/
export MY_CMAKE_EXE_DIR=$ANDROID_HOME/cmake/${v_cmake}/bin/

"${MY_CMAKE_EXE_DIR}/ninja" -C $build -j$cores
DESTDIR="$prefix_dir" "${MY_CMAKE_EXE_DIR}/ninja" -C $build install


# add missing library for static linking
# this isn't "-lstdc++" due to a meson bug: https://github.com/mesonbuild/meson/issues/11300
sed '/^Libs:/ s|$| -lc++_static -lc++abi|' "$prefix_dir/lib/pkgconfig/libplacebo.pc" -i