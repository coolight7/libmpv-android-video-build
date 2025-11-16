#!/bin/bash -e

## Dependency versions

v_platform=android-36
# https://developer.android.google.cn/studio?hl=zh-cn#command-tools
v_sdk=13114758_latest
# https://developer.android.google.cn/ndk/downloads/?hl=zh-cn
# 编译ffmpeg8.0不能用 ndk 27或以下，28未尝试，29可行
v_ndk=29.0.14206865
# https://developer.android.google.cn/tools/releases/platform-tools?hl=zh-cn
v_sdk_build_tools=36.1.0
v_cmake=3.31.6
v_min_sdk=24

v_libass=0.17.4
v_libunibreak=6.1
v_harfbuzz=12.1.0
v_fribidi=1.0.16
v_freetype=2-14-1
v_mbedtls=3.6.4
v_shaderc=2025.3
v_dav1d=1.5.1
v_libxml2=2.15.0
v_libplacebo=7.351.0
v_ffmpeg=8.0
v_mpv=0.40.0
v_libogg=1.3.6
v_libvpx=1.14


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_harfbuzz=()
dep_fribidi=()
dep_libunibreak=()
dep_zstd=()
dep_zlib=()
dep_brotli=()
dep_shaderc=()
dep_opus_dnn=()
dep_libbs2b=()
dep_libsoxr=()
dep_expat=()
dep_bzip2=()
dep_lzo=()
dep_xz=()
dep_libsamplerate=()
dep_libpng=()
dep_libjpeg=()
dep_highway=()
dep_uchardet=()
dep_libzimg=()
dep_spirv_cross=()
dep_libiconv=()
dep_libmysofa=(zlib)
dep_libvorbis=(libogg)
dep_harfbuzz=(libpng)
dep_rubberband=(libsamplerate)
dep_lcms2=(libjpeg zlib)
dep_libwebp=(zlib libpng libjpeg)
dep_openssl=(zlib zstd brotli)
dep_libjxl=(lcms2 highway libpng brotli)
dep_freetype=(zlib harfbuzz brotli)
dep_fontconfig=(freetype libiconv expat)
dep_libxml2=(zlib libiconv)
dep_libarchive=(libxml2 openssl expat bzip2 lzo xz)
dep_libass=(freetype fribidi libunibreak libiconv harfbuzz)
dep_libplacebo=(shaderc lcms2 spirv_cross)
dep_opus=(opus_dnn)

# 依赖项的依赖已有，则不需要重复依赖编译
dep_ffmpeg=(libarchive uchardet libass mbedtls dav1d libxml2 libplacebo libvorbis libvpx libbs2b opus libsoxr openssl bzip2 rubberband libmysofa libwebp libjxl libzimg)
dep_mpv=(ffmpeg)
dep_mediaxx=(mpv)
