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

current_source_dir=$(pwd)
mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

cpu=armv7-a
cpuflags=
asmflags=
if [[ "$ndk_triple" == "aarch64"* ]]; then
	cpu=armv8-a
  	asmflags=" --enable-neon --enable-asm --enable-inline-asm"
elif [[ "$ndk_triple" == "arm"* ]]; then
 	cpu=armv7-a
	cpuflags="$cpuflags -mfpu=neon -mcpu=cortex-a8"
	asmflags=" --enable-neon --enable-asm --enable-inline-asm"
elif [[ "$ndk_triple" == "x86_64"* ]]; then
	cpu=generic
	asmflags=" --disable-neon --enable-asm --enable-inline-asm"
elif [[ "$ndk_triple" == "i686"* ]]; then
	cpu="i686 --disable-asm"
	# asm disabled due to this ticket https://trac.ffmpeg.org/ticket/4928
	asmflags=" --disable-neon --disable-asm --disable-inline-asm"
fi 

ANDROID_SYSROOT=${NDK_PREFIX_DIR}/sysroot

# c++std: libjxl、shaderc
# 链接c++标准库时，需要静态链接
# --extra-ldflags="-L$prefix_dir/lib -lm -nostdlib++ -lc++_static -lc++abi"
# [vulkan] 会增加 5mb 左右的大小，但可能对ffmpeg用处不大
../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- \
	--arch=${ndk_triple%%-*} --cpu=$cpu \
	--nm=llvm-nm --strip=llvm-strip --ranlib=$RANLIB --ar=$AR --cc=$CC --cxx=$CXX \
	--pkg-config=pkg-config \
	--stdc=c23 --stdcxx=c++23 \
  	--sysroot="${ANDROID_SYSROOT}" \
	--extra-cflags="-Wno-error=int-conversion -Wno-error=incompatible-function-pointer-types -I$prefix_dir/include $cpuflags" \
	--extra-ldflags="-L$prefix_dir/lib -lm -nostdlib++ -lc++_static -lc++abi" \
	--pkg-config-flags=--static \
	\
	--enable-gpl \
	--enable-nonfree \
	--enable-version3 \
	\
    --disable-debug \
	--disable-static \
	--enable-shared \
	--enable-stripping \
	--enable-runtime-cpudetect \
	--enable-small \
	--enable-pic \
	--enable-lto \
	--enable-lto=full \
	--enable-hwaccels \
	--enable-optimizations \
	${asmflags} \
	--enable-pthreads \
	\
	--disable-muxers \
	--disable-decoders \
	--disable-encoders \
	--disable-demuxers \
	--disable-parsers \
	--disable-protocols \
	--disable-devices \
	--disable-filters \
	--disable-programs \
	--disable-ffmpeg \
	--disable-ffprobe \
	--disable-swscale-alpha \
	--disable-gray \
	--disable-doc \
	--disable-htmlpages \
	--disable-manpages \
	--disable-podpages \
	--disable-txtpages \
	--disable-xmm-clobber-test \
	--disable-neon-clobber-test \
	--disable-version-tracking \
	\
	--enable-avutil \
	--enable-avcodec \
	--enable-avfilter \
	--enable-avformat \
	--enable-avdevice \
	--enable-swscale \
	--enable-swresample \
	\
	--disable-libmfx \
	--disable-avisynth \
	--disable-vapoursynth \
    --disable-whisper \
	--disable-libbluray \
	--disable-libdvdnav \
	--disable-libdvdread \
	--disable-libmodplug \
	--disable-libopenmpt \
	--disable-libx264 \
	--disable-libx265 \
	--disable-libsrt \
	--disable-libzvbi \
	--disable-libaribcaption \
	--disable-libxvid \
	--disable-amf \
	--disable-libmp3lame \
	--disable-libssh \
	--disable-libvpl \
	--disable-libspeex \
    --disable-libaom \
	--disable-libsvtav1 \
	\
	--enable-network \
	--enable-libass \
	--enable-libfreetype \
	--enable-libfribidi \
	--enable-libharfbuzz \
	--enable-libopus \
	--enable-libsoxr \
	--enable-libvorbis \
	--enable-libbs2b \
	--enable-librubberband \
	--enable-libvpx \
	--enable-libwebp \
	--enable-libdav1d \
	--enable-lcms2 \
	--enable-libzimg \
	--enable-openssl \
	--enable-libxml2 \
	--enable-libmysofa \
	--enable-libjxl \
	--enable-libplacebo \
	--enable-libshaderc \
	--disable-iconv \
	--disable-libdavs2 \
	--disable-libuavs3d \
	--disable-libfontconfig \
	\
	--disable-d3d11va \
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vdpau \
	--disable-bzlib \
	--disable-linux-perf \
	--disable-appkit \
	--disable-videotoolbox \
	--disable-audiotoolbox \
	--disable-v4l2-m2m \
	--disable-mmal \
	--enable-jni \
	--enable-mediacodec \
	--disable-vulkan \
    --disable-vulkan-static \
	\
	--enable-indevs \
	--enable-outdevs \
	--disable-indev=libcdio,v4l2,android_camera,decklink,dshow,gdigrab,iec61883,kmsgrab,libdc1394,vfwcap,xcbgrab,fbdev \
	--disable-outdev=caca,fbdev,v4l2,avfoundation \
	\
	--enable-bsfs \
	--disable-bsf=mov2textsub,text2movsub \
	\
	--disable-encoders \
	--enable-encoder=mjpeg* \
	--enable-encoder=ljpeg \
	--enable-encoder=jpegls \
	--enable-encoder=jpeg2000 \
	--enable-encoder=apng \
	--enable-encoder=png \
	--enable-encoder=gif \
	--enable-encoder=wbmp \
	--enable-encoder=libwebp \
	--enable-encoder=libwebp_anim \
	--enable-encoder=anull,vnull \
	\
	--enable-decoders \
	--enable-decoder=*_mediacodec \
	--disable-decoder=*_mmal,*_v4l2m2m \
	\
    --enable-parsers \
	\
	--disable-muxers \
	--enable-muxer=image2,image2pipe,mjpeg,mpjpeg,smjpeg,apng,avif,fits,filmstrip,gif,ico,webp \
	\
	--enable-demuxers \
	\
    --disable-filters \
	--disable-filter=adeclick,afftd,afwtd,anlmd,arnnd,dcshif,deesse,fftdnoi,avsynctes,fsyn,realtim,arevers,showinfo \
	--enable-filter=format \
	--enable-filter=aformat \
	--enable-filter=noformat \
	--enable-filter=hwdownload \
	--enable-filter=hwupload \
	--enable-filter=copy \
	--enable-filter=showwavespic \
	--enable-filter=acompressor \
	--enable-filter=alimiter \
	--enable-filter=atrim \
	--enable-filter=aecho \
	--enable-filter=acopy \
	--enable-filter=amovie \
	--enable-filter=apulsator \
	--enable-filter=bs2b \
	--enable-filter=bass \
	--enable-filter=compand \
	--enable-filter=equalizer \
	--enable-filter=loudnorm \
	--enable-filter=metadata \
	--enable-filter=pan \
	--enable-filter=stereotools \
	--enable-filter=rubberband \
	--enable-filter=volume \
	--enable-filter=volumedetect \
	--enable-filter=null \
	--enable-filter=nullsink \
	--enable-filter=nullsrc \
	--enable-filter=anull \
	--enable-filter=anullsink \
	--enable-filter=anullsrc \
	\
	--enable-filter=aselect \
	--enable-filter=adeclip \
	--enable-filter=atempo \
	--enable-filter=sinc \
	--enable-filter=sine \
	--enable-filter=amix \
	--enable-filter=amerge \
	--enable-filter=asetpts \
	--enable-filter=aresample \
	\
	--disable-protocols \
	--disable-protocol=ffrtmphttp,rtmp,rtmps,rtmpt,rtmpts,rtp,srtp,libsrt,libssh \
	--enable-protocol=async \
	--enable-protocol=cache \
	--enable-protocol=crypto \
	--enable-protocol=data \
	--enable-protocol=file \
	--enable-protocol=ftp \
	--enable-protocol=hls \
	--enable-protocol=pipe \
	--enable-protocol=http \
	--enable-protocol=httpproxy \
	--enable-protocol=https \
	--enable-protocol=subfile \
	--enable-protocol=tcp \
	--enable-protocol=tls \
	--enable-protocol=udp

# - 报错找不到依赖包时，也可能是 configure 尝试使用依赖库编译测试程序失败：
# 	- 其中可能是 cpu平台不正确、符号缺失、缺少 include搜索目录或链接搜索目录、缺少指定链接库名称等原因

make -s -j$cores
make -s DESTDIR="$prefix_dir" install > /dev/null

echo "$(ls -lh $prefix_dir/lib/libav*)"