#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# mbedtls
[ ! -d mbedtls ] && git clone --depth 1 --branch v$v_mbedtls --recurse-submodules https://github.com/Mbed-TLS/mbedtls.git mbedtls

# dav1d
[ ! -d dav1d ] && git clone --depth 1 --branch $v_dav1d https://code.videolan.org/videolan/dav1d.git dav1d

# libxml2
[ ! -d libxml2 ] && git clone --depth 1 --branch v$v_libxml2 --recursive https://gitlab.gnome.org/GNOME/libxml2.git libxml2

# libogg
[ ! -d libogg ] && $WGET https://github.com/xiph/ogg/releases/download/v${v_libogg}/libogg-${v_libogg}.tar.gz && tar -xf libogg-${v_libogg}.tar.gz && mv libogg-${v_libogg} libogg && rm libogg-${v_libogg}.tar.gz

# libvorbis
[ ! -d libvorbis ] && git clone --depth 1 https://github.com/xiph/vorbis libvorbis

# libvpx
[ ! -d libvpx ] && git clone --depth 1 --branch meson-$v_libvpx https://gitlab.freedesktop.org/gstreamer/meson-ports/libvpx.git libvpx

# libx264
[ ! -d libx264 ] && git clone --depth 1 https://code.videolan.org/videolan/x264.git --branch master libx264

# libzimg
[ ! -d libzimg ] && git clone --depth 1 --recurse-submodules https://bitbucket.org/the-sekrit-twc/zimg.git libzimg

# ffmpeg
[ ! -d ffmpeg ] && git clone --depth 1 --branch n$v_ffmpeg https://github.com/FFmpeg/FFmpeg.git ffmpeg

# freetype
[ ! -d freetype ] && git clone --depth 1 --branch VER-$v_freetype https://gitlab.freedesktop.org/freetype/freetype.git freetype

# fribidi
[ ! -d fribidi ] && git clone --depth 1 --branch v$v_fribidi https://github.com/fribidi/fribidi.git fribidi

# harfbuzz
[ ! -d harfbuzz ] && git clone --depth 1 --branch $v_harfbuzz https://github.com/harfbuzz/harfbuzz.git harfbuzz

# libunibreak
if [ ! -d libunibreak ]; then
        mkdir libunibreak
        $WGET https://github.com/adah1972/libunibreak/releases/download/libunibreak_${v_libunibreak//./_}/libunibreak-${v_libunibreak}.tar.gz -O - | \
                tar -xz -C libunibreak --strip-components=1
fi

# libass
[ ! -d libass ] && git clone --depth 1 --branch $v_libass https://github.com/libass/libass.git libass

# shaderc
if [ ! -d shaderc ]; then
	git clone --depth 1 --branch v$v_shaderc --recursive https://github.com/google/shaderc shaderc
	cd shaderc/utils
	./git-sync-deps
	cd ../..
fi

# libplacebo
[ ! -d libplacebo ] && git clone --depth 1 --branch v$v_libplacebo --recurse-submodules https://code.videolan.org/videolan/libplacebo.git libplacebo

# shaderc
mkdir -p shaderc
cat >shaderc/README <<'HEREDOC'
Shaderc sources are provided by the NDK.
see <ndk>/sources/third_party/shaderc
HEREDOC

# libbs2b
[ ! -d libbs2b ] && git clone --depth 1 https://github.com/alexmarsev/libbs2b.git libbs2b

# opus-dnn
[ ! -d "$prefix_dir/opus_dnn" ] && $WGET https://media.xiph.org/opus/models/opus_data-8a07d57c4fce6fb30f23b3e0d264004e04f1d7b421f5392ef61543d021a439af.tar.gz && tar -zxvf opus_data-8a07d57c4fce6fb30f23b3e0d264004e04f1d7b421f5392ef61543d021a439af.tar.gz && mv dnn opus_dnn && rm opus_data-8a07d57c4fce6fb30f23b3e0d264004e04f1d7b421f5392ef61543d021a439af.tar.gz

# opus
[ ! -d opus ] && git clone --depth 1 https://github.com/xiph/opus.git opus

# libsoxr
[ ! -d libsoxr ] && git clone --depth 1 https://gitlab.com/shinchiro/soxr.git libsoxr

# fontconfig
[ ! -d fontconfig ] && git clone --depth 1 https://gitlab.freedesktop.org/fontconfig/fontconfig.git fontconfig

# libiconv
[ ! -d libiconv ] && $WGET https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.18.tar.gz && tar -zxvf libiconv-1.18.tar.gz && mv libiconv-1.18 libiconv && rm libiconv-1.18.tar.gz

# zstd
[ ! -d zstd ] && git clone --depth 1 --branch dev https://github.com/facebook/zstd.git zstd

# zlib
[ ! -d zlib ] && git clone --depth 1 --branch develop https://github.com/zlib-ng/zlib-ng.git zlib

# expat
[ ! -d expat ] && git clone --depth 1 https://github.com/libexpat/libexpat.git expat

# bzip2
[ ! -d bzip2 ] && git clone --depth 1 https://gitlab.com/bzip2/bzip2.git bzip2

# lzo
[ ! -d lzo ] && $WGET https://fossies.org/linux/misc/lzo-2.10.tar.gz && tar -zxvf lzo-2.10.tar.gz && mv lzo-2.10 lzo && rm lzo-2.10.tar.gz

# uchardet
[ ! -d uchardet ] && git clone --depth 1 https://gitlab.freedesktop.org/uchardet/uchardet.git uchardet

# spirv_cross
[ ! -d spirv_cross ] && git clone --depth 1 https://github.com/KhronosGroup/SPIRV-Cross.git spirv_cross

# xz
[ ! -d xz ] && git clone --depth 1 https://gitlab.com/shinchiro/xz.git xz

# libjpeg
[ ! -d libjpeg ] && git clone --depth 1 https://github.com/libjpeg-turbo/libjpeg-turbo.git libjpeg

# libpng
[ ! -d libpng ] && git clone --depth 1 https://github.com/glennrp/libpng.git libpng

# libwebp
[ ! -d libwebp ] && git clone --depth 1 https://chromium.googlesource.com/webm/libwebp.git libwebp

# highway
[ ! -d highway ] && git clone --depth 1 https://github.com/google/highway.git highway

# lcms2
[ ! -d lcms2 ] && git clone --depth 1 https://github.com/mm2/Little-CMS.git lcms2

# libsamplerate
[ ! -d libsamplerate ] && git clone --depth 1 https://github.com/libsndfile/libsamplerate.git libsamplerate

# rubberband
[ ! -d rubberband ] && git clone --depth 1 https://github.com/breakfastquay/rubberband.git rubberband

# libmysofa
[ ! -d libmysofa ] && git clone --depth 1 https://github.com/hoene/libmysofa.git libmysofa

# openssl
[ ! -d openssl ] && git clone --depth 1 https://github.com/openssl/openssl.git openssl

# libarchive
[ ! -d libarchive ] && git clone --depth 1 https://github.com/libarchive/libarchive.git libarchive

# libjxl
[ ! -d libjxl ] && git clone --depth 1 https://github.com/libjxl/libjxl.git libjxl && cd libjxl && git submodule update --init && cd ..
cd libjxl && rm -rf ./third_party/libjpeg-turbo && ln -s ../libjpeg ./third_party/libjpeg-turbo && cd ..

# brotli
[ ! -d brotli ] && git clone --depth 1 https://github.com/google/brotli.git brotli

# mpv
[ ! -d mpv ] && git clone --depth 1 --branch v$v_mpv https://github.com/mpv-player/mpv.git mpv

# fftools_ffi
[ ! -d fftools_ffi ] && git clone --depth 1 --branch main https://github.com/moffatman/fftools-ffi.git fftools_ffi

# mediaxx
[ ! -d mediaxx ] && git clone --depth 1 https://github.com/coolight7/mediaxx mediaxx

# media-kit-android-helper
[ ! -d media-kit-android-helper ] && git clone --branch main https://github.com/coolight7/media-kit-android-helper && cd media-kit-android-helper && git reset --hard 6498016ba41c18cf229b2efefb06d9377e18b572
echo "sdk.dir=/home/coolight/program/media/libmpv-android-video-build/buildscripts/sdk/android-sdk-linux/" > local.properties && cd ..

# media_kit
[ ! -d media_kit ] && git clone --depth 1 --single-branch --branch main https://github.com/alexmercerind/media_kit.git && cd ..
