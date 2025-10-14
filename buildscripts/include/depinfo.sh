#!/bin/bash -e

## Dependency versions

v_platform=android-36
# https://developer.android.google.cn/studio?hl=zh-cn#command-tools
v_sdk=13114758_latest
# https://developer.android.google.cn/ndk/downloads/?hl=zh-cn
v_ndk=27.3.13750724
# https://developer.android.google.cn/tools/releases/platform-tools?hl=zh-cn
v_sdk_build_tools=36.1.0
v_cmake=3.31.6

v_libass=0.17.4
v_libunibreak=6.1
v_harfbuzz=12.1.0
v_fribidi=1.0.16
v_freetype=2-14-1
v_mbedtls=3.6.4
v_dav1d=1.5.1
v_libxml2=2.15.0
v_libplacebo=7.351.0
v_ffmpeg=7.1.2
v_mpv=0.40.0
v_libogg=1.3.6
v_libvorbis=1.3.7
v_libvpx=1.14


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_libvorbis=(libogg)
if [ -n "$ENCODERS_GPL" ]; then
	dep_ffmpeg=(mbedtls dav1d libxml2 libvorbis libvpx libx264)
else
	dep_ffmpeg=(mbedtls dav1d libxml2)
fi
dep_freetype2=(harfbuzz)
dep_fribidi=()
dep_harfbuzz=()
dep_libunibreak=()
dep_libplacebo=()
dep_libass=(freetype fribidi harfbuzz libunibreak)
dep_shaderc=()
if [ -n "$ENCODERS_GPL" ]; then
	dep_mpv=(ffmpeg libass libplacebo fftools_ffi)
else
	dep_mpv=(ffmpeg libass libplacebo)
fi
