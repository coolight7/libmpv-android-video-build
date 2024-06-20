#!/bin/bash -e

## Dependency versions

v_sdk=11076708_latest
v_ndk=26.3.11579264
v_sdk_build_tools=34.0.0

v_libass=0.17.2
v_harfbuzz=8.5.0
v_fribidi=1.0.15
v_freetype=2-13-0
v_mbedtls=3.5.2
v_dav1d=1.4.2
v_libxml2=2.10.3
v_libplacebo=6.338.2
v_ffmpeg=7.0.1
v_mpv=0.38.0
v_libogg=1.3.5
v_libvorbis=1.3.7
v_libvpx=1.13


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
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_libass=(freetype fribidi harfbuzz)
dep_lua=()
dep_shaderc=()
if [ -n "$ENCODERS_GPL" ]; then
	dep_mpv=(ffmpeg libass fftools_ffi libplacebo)
else
	dep_mpv=(ffmpeg libass libplacebo)
fi
