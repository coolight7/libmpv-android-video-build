#!/bin/bash -e

cd "$( dirname "${BASH_SOURCE[0]}" )"
. ./include/depinfo.sh

cleanbuild=0
clean_lib_ff_mpv=0
clean_mediaxx=0
nodeps=0
target=mediaxx
archs=(armv7l arm64 x86 x86_64)

getdeps () {
	varname="dep_${1//-/_}[*]"
	echo ${!varname}
}

loadarch () {
	unset CC CXX CPATH LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
    unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

	# ndk_triple: what the toolchain actually is
	# cc_triple: what Google pretends the toolchain is
	if [ "$1" == "armv7l" ]; then
		export ndk_suffix=
		export ndk_triple=arm-linux-androideabi
		cc_triple=armv7a-linux-androideabi$v_min_sdk
		prefix_name=armeabi-v7a
	elif [ "$1" == "arm64" ]; then
		export ndk_suffix=-arm64
		export ndk_triple=aarch64-linux-android
		cc_triple=$ndk_triple$v_min_sdk
		prefix_name=arm64-v8a
	elif [ "$1" == "x86" ]; then
		export ndk_suffix=-x86
		export ndk_triple=i686-linux-android
		cc_triple=$ndk_triple$v_min_sdk
		prefix_name=x86
	elif [ "$1" == "x86_64" ]; then
		export ndk_suffix=-x64
		export ndk_triple=x86_64-linux-android
		cc_triple=$ndk_triple$v_min_sdk
		prefix_name=x86_64
	else
		echo "Invalid architecture"
		exit 1
	fi
	export current_abi_name=$prefix_name
	export default_cxx_stl="c++_static"
	export default_ld_cxx_stdlib_unset=" -nostdlib++ "
	export default_ld_cxx_stdlib=" -nostdlib++ -l$default_cxx_stl -lc++abi "
	export default_ld_cxx_stdlib_mediaxx=" -nostdlib++ -lc++_static -lc++abi "
	export build_home_dir="$PWD/../"
	export prefix_dir="$PWD/prefix/$prefix_name"
	export source_dir="$PWD/deps/"
	export CFLAGS="-fPIC -ffunction-sections -fdata-sections "
	export CXXFLAGS="-fPIC -ffunction-sections -fdata-sections "
	export LDFLAGS="-Wl,-O2,--icf=safe -Wl,-z,max-page-size=16384 -Wl,--gc-sections"
	export native_dir="$PWD/../libmpv/src/main/jniLibs/$prefix_name"
	export CC=$cc_triple-clang
	if [[ "$1" == arm* ]]; then
		export AS="$CC"
	else
		export AS="nasm"
	fi
	export CXX=$cc_triple-clang++
	export AR=llvm-ar
	export RANLIB=llvm-ranlib
}

setup_prefix () {
	if [ ! -d "$prefix_dir" ]; then
		mkdir -p "$prefix_dir"
		mkdir -p "$prefix_dir/lib"
    	mkdir -p "$prefix_dir/lib/pkgconfig"
    	mkdir -p "$prefix_dir/include"
		# enforce flat structure (/usr/local -> /)
		ln -s . "$prefix_dir/usr"
		ln -s . "$prefix_dir/local"
	fi
	
	if [ ! -d "$native_dir" ]; then
		mkdir -p "$native_dir"
	fi

	local cpu_family=${ndk_triple%%-*}
	[ "$cpu_family" == "i686" ] && cpu_family=x86
	
	. ./include/path.sh

	# meson wants to be spoonfed this file, so create it ahead of time
	# also define: release build, static libs and no source downloads at runtime(!!!)
	cat >"$prefix_dir/crossfile.txt" <<CROSSFILE
[built-in options]
buildtype = 'release'
default_library = 'static'
wrap_mode = 'nodownload'
c_args = '-fPIC -ffunction-sections -fdata-sections'
cpp_args = '-fPIC -ffunction-sections -fdata-sections'

[binaries]
c = '$CC'
cpp = '$CXX'
ar = 'llvm-ar'
nm = 'llvm-nm'
strip = 'llvm-strip'
pkg-config = 'pkg-config'

[properties]
pkg_config_path = '$prefix_dir/lib/pkgconfig'

[host_machine]
system = 'android'
cpu_family = '$cpu_family'
cpu = '${CC%%-*}'
endian = 'little'
CROSSFILE

# Android provides Vulkan, but no pkgconfig file
# you can double-check the version in vk.xml (ctrl+f VK_API_VERSION)
mkdir -p "$prefix_dir"/lib/pkgconfig
cat >"$prefix_dir"/lib/pkgconfig/vulkan.pc <<VULKAN_PC
Name: Vulkan
Description:
Version: 1.3.275
Libs: -L$NDK_PREFIX_MINSDK_DIR/ -lvulkan
Cflags: -fPIC -I$NDK_PREFIX_DIR/sysroot/usr/include
VULKAN_PC
}

build () {
	if [ ! -d deps/$1 ]; then
		printf >&2 '\e[1;31m%s\e[m\n' "Target $1 not found"
		return 1
	fi
	if [ $nodeps -eq 0 ]; then
		printf >&2 '\e[1;34m%s\e[m\n' "Preparing $1..."
		local deps=$(getdeps $1)
		echo >&2 "Dependencies: $deps"
		for dep in $deps; do
			build $dep
		done
	fi

	printf >&2 '\e[1;34m%s\e[m\n' "Building $1..."

	if [[ -f "$prefix_dir/lib/$1.a" 
		|| -f "$prefix_dir/lib/lib$1.a" 
		|| ( $1 == "lzo" && -f "$prefix_dir/lib/liblzo2.a" ) 
		|| ( $1 == "zlib" && -f "$prefix_dir/lib/libz.a" ) 
		|| ( $1 == "bzip2" && -f "$prefix_dir/lib/libbz2_static.a" ) 
		|| ( $1 == "brotli" && -f "$prefix_dir/lib/libbrotlicommon.a" ) 
		|| ( $1 == "xz" && -f "$prefix_dir/lib/liblzma.a" ) 
		|| ( $1 == "highway" && -f "$prefix_dir/lib/libhwy.a" ) 
		|| ( $1 == "shaderc" && -f "$prefix_dir/lib/libshaderc_combined.a" ) 
		|| ( $1 == "spirv_cross" && -f "$prefix_dir/lib/libspirv-cross-c.a" ) 
		|| ( $1 == "openssl" && -f "$prefix_dir/lib/libssl.a" ) 
		# || ( $1 == "ffmpeg")
		|| ( $1 == "ffmpeg" && -f "$prefix_dir/lib/libavfilter.a") 
		# || ( $1 == "ffmpeg" && -f "$prefix_dir/lib/libavfilter.so")
		|| ( $1 == "mpv" && -f "$prefix_dir/lib/libmpv.so" ) 
		]]; then
		return
	fi

	pushd deps/$1
	BUILDSCRIPT=../../scripts/$1.sh
 	sudo chmod +x $BUILDSCRIPT
	$BUILDSCRIPT clean

    $BUILDSCRIPT build
    popd
}

usage () {
	printf '%s\n' \
		"Usage: build.sh [options] [target]" \
		"Builds the specified target (default: $target)" \
		"-n             Do not build dependencies" \
		"--clean        Clean build dirs before compiling" \
		"--arch <arch>  Build for specified architecture (supported: armv7l, arm64, x86, x86_64)"
	exit 0
}

while [ $# -gt 0 ]; do
	case "$1" in
		--clean)
		cleanbuild=1
		;;
		-n|--no-deps)
		nodeps=1
		;;
		--arch)
		shift
		arch=$1
		;;
		-h|--help)
		usage
		;;
		--prebuild-rm-ff-mpv)
		clean_lib_ff_mpv=1
		rm -rf $source_dir/ffmpeg/_build*
		rm -rf $source_dir/mpv/_build*
		rm -rf $source_dir/mediaxx/_build*
		;;
		--prebuild-rm-mediaxx)
		clean_mediaxx=1
		rm -rf $source_dir/mediaxx/_build*
		;;
		*)
		target=$1
		;;
	esac
	shift
done

if [ -z $arch ]; then
	for arch in ${archs[@]}; do
		loadarch $arch
		setup_prefix
		
		if [[ $clean_lib_ff_mpv == 1 ]]; then
			echo "rm libav*/libmpv/mediaxx ----------------------"
			rm -f $prefix_dir/lib/libavcodec.*
			rm -f $prefix_dir/lib/libavdevice.*
			rm -f $prefix_dir/lib/libavfilter.*
			rm -f $prefix_dir/lib/libavformat.*
			rm -f $prefix_dir/lib/libavutil.*
			rm -f $prefix_dir/lib/libswresample.*
			rm -f $prefix_dir/lib/libswscale.*
			rm -rf $prefix_dir/lib/ffmpeg-backup/

			rm -f $prefix_dir/lib/libmpv.*
			rm -f $prefix_dir/lib/libmediaxx.*
		elif [[ $clean_mediaxx == 1 ]]; then
			echo "rm libav*/libmpv/mediaxx ----------------------"
			rm -f $prefix_dir/lib/libmediaxx.*
		fi

		env > "$PWD/env-$arch.sh"
		chmod +x "$PWD/env-$arch.sh"
		build $target
	done
else
  	loadarch $arch
  	setup_prefix

	if [[ $clean_lib_ff_mpv == 1 ]]; then
		echo "rm libav*/libmpv/mediaxx ----------------------"
		rm -f $prefix_dir/lib/libavcodec.*
		rm -f $prefix_dir/lib/libavdevice.*
		rm -f $prefix_dir/lib/libavfilter.*
		rm -f $prefix_dir/lib/libavformat.*
		rm -f $prefix_dir/lib/libavutil.*
		rm -f $prefix_dir/lib/libswresample.*
		rm -f $prefix_dir/lib/libswscale.*
		rm -rf $prefix_dir/lib/ffmpeg-backup/

		rm -f $prefix_dir/lib/libmpv.*
		rm -f $prefix_dir/lib/libmediaxx.*
	elif [[ $clean_mediaxx == 1 ]]; then
		echo "rm libav*/libmpv/mediaxx ----------------------"
		rm -f $prefix_dir/lib/libmediaxx.*
	fi
  	build $target
fi

exit 0
