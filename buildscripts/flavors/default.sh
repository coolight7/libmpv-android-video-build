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
	asmflags=" --disable-neon --enable-asm --enable-inline-asm"
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
../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- \
	--arch=${ndk_triple%%-*} --cpu=$cpu \
	--ar=$AR --cc=$CC --ranlib=$RANLIB \
	--pkg-config=pkg-config --nm=llvm-nm --strip=llvm-strip \
  	--sysroot="${ANDROID_SYSROOT}" \
	--extra-cflags="-Wno-error=int-conversion -I$prefix_dir/include $cpuflags" \
	--extra-ldflags="-L$prefix_dir/lib -lm -nostdlib++ -lc++_static -lc++abi" \
	--pkg-config-flags=--static \
	\
	--enable-gpl \
	--enable-nonfree \
	--enable-version3 \
	\
    --disable-debug \
	--enable-shared \
	--disable-static \
	--enable-stripping \
	--enable-runtime-cpudetect \
	--enable-small \
	--enable-pic \
	--enable-lto \
	--enable-lto=thin \
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
	\
	--disable-postproc \
	--enable-avutil \
	--enable-avcodec \
	--enable-avfilter \
	--enable-avformat \
	--enable-avdevice \
	--enable-swscale \
	--enable-swresample \
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
	--disable-vulkan \
	--enable-jni \
	--enable-mediacodec \
	\
	--enable-indevs \
	--enable-outdevs \
	--disable-indev=libcdio \
	--disable-indev=v4l2 \
	--disable-indev=android_camera \
	--disable-indev=decklink \
	--disable-indev=dshow \
	--disable-indev=gdigrab \
	--disable-indev=iec61883 \
	--disable-indev=kmsgrab \
	--disable-indev=libdc1394 \
	--disable-indev=vfwcap \
	--disable-indev=xcbgrab \
	--disable-indev=fbdev \
	--disable-outdev=caca \
	--disable-outdev=fbdev \
	\
	--enable-bsfs \
	--disable-bsf=mov2textsub \
	--disable-bsf=text2movsub \
	\
	--enable-decoders \
	--enable-decoder=aac_mediacodec \
	--enable-decoder=amrnb_mediacodec \
	--enable-decoder=amrwb_mediacodec \
	--enable-decoder=av1_mediacodec \
	--enable-decoder=h264_mediacodec \
	--enable-decoder=hevc_mediacodec \
	--enable-decoder=mp3_mediacodec \
	--enable-decoder=mpeg2_mediacodec \
	--enable-decoder=mpeg4_mediacodec \
	--enable-decoder=vp8_mediacodec \
	--enable-decoder=vp9_mediacodec \
	--enable-decoder=opus_mediacodec \
	--enable-decoder=vorbis_mediacodec \
	--disable-decoder=h263_v4l2m2m \
	--disable-decoder=h264_v4l2m2m \
	--disable-decoder=hevc_v4l2m2m \
	--disable-decoder=mpeg1_v4l2m2m \
	--disable-decoder=vc1_v4l2m2m \
	--disable-decoder=mpeg2_v4l2m2m \
	--disable-decoder=mpeg4_v4l2m2m \
	--disable-decoder=vp8_v4l2m2m \
	--disable-decoder=vp9_v4l2m2m \
	--disable-decoder=mpeg2_mmal \
	--disable-decoder=h264_mmal \
	--disable-decoder=vp8_mmal \
	--disable-decoder=dvbsub \
	--disable-decoder=dvdsub \
	--disable-decoder=jacosub \
	--disable-decoder=realtext \
	--disable-decoder=stl \
	--disable-decoder=microdvd \
	--disable-decoder=mpl2 \
	\
	--disable-muxers \
	--enable-muxer=image2 \
	--enable-muxer=image2pipe \
	--enable-muxer=mjpeg \
	--enable-muxer=mpjpeg \
	--enable-muxer=apng \
	--enable-muxer=avif \
	--enable-muxer=fits \
	--enable-muxer=gif \
	--enable-muxer=ico \
	--enable-muxer=webp \
	\
	--enable-demuxers \
	--disable-demuxer=vobsub \
	--disable-demuxer=dvbsub \
	--disable-demuxer=dvbtxt \
	--disable-demuxer=mpl2 \
	--disable-demuxer=aqtitle \
	--disable-demuxer=jacosub \
	--disable-demuxer=realtext \
	--disable-demuxer=tedcaptions \
	--disable-demuxer=stl \
	--disable-demuxer=ace \
	--disable-demuxer=gxf \
	--disable-demuxer=live_flv \
	--disable-demuxer=lxf \
	--disable-demuxer=microdvd \
	--disable-demuxer=rtp \
	--disable-demuxer=rtsp \
	\
    --enable-parsers \
	\
    --disable-filters \
	--disable-filter=adeclick \
	--disable-filter=afftdn \
	--disable-filter=afwtdn \
	--disable-filter=anlmdn \
	--disable-filter=arnndn \
	--disable-filter=dcshift \
	--disable-filter=deesser \
	--disable-filter=fftdnoiz \
	--disable-filter=avsynctest \
	--disable-filter=fsync \
	--disable-filter=realtime \
	--disable-filter=areverse \
	--disable-filter=showinfo \
	--disable-filter=showframes \
	\
	--enable-filter=thumbnail \
	--enable-filter=select \
	--enable-filter=trim \
	--enable-filter=atrim \
	--enable-filter=fps \
	--enable-filter=movie \
	--enable-filter=metadata \
	--enable-filter=null \
	--enable-filter=nullsink \
	--enable-filter=nullsrc \
	--enable-filter=anull \
	--enable-filter=anullsink \
	--enable-filter=anullsrc \
	--enable-filter=adeclip \
	--enable-filter=acopy \
	--enable-filter=asetpts \
	--enable-filter=setpts \
	--enable-filter=amix \
	--enable-filter=amerge \
	--enable-filter=aresample \
	--enable-filter=asplit \
	--enable-filter=copy \
	--enable-filter=drawtext \
	--enable-filter=volume \
	--enable-filter=volumedetect \
	--enable-filter=acompressor \
	--enable-filter=adrc \
	--enable-filter=dynaudnorm \
	--enable-filter=limiter \
	--enable-filter=mcompand \
	--enable-filter=anequalizer \
	--enable-filter=bandpass \
	--enable-filter=bandreject \
	--enable-filter=bass \
	--enable-filter=equalizer \
	--enable-filter=highpass \
	--enable-filter=highshelf \
	--enable-filter=lowpass \
	--enable-filter=lowshelf \
	--enable-filter=midequalizer \
	--enable-filter=tiltshelf \
	--enable-filter=aecho \
	--enable-filter=aphaser \
	--enable-filter=bs2b \
	--enable-filter=crystalizer \
	--enable-filter=flanger \
	--enable-filter=haas \
	--enable-filter=headphone \
	--enable-filter=extrastereo \
	--enable-filter=sofalizer \
	--enable-filter=stereotools \
	--enable-filter=stereowiden \
	--enable-filter=surround \
	--enable-filter=tremolo \
	--enable-filter=vibrato \
	--enable-filter=virtualbass \
	--enable-filter=ebur128 \
	--enable-filter=loudnorm \
	--enable-filter=replaygain \
	--enable-filter=silencedetect \
	--enable-filter=silenceremove \
	--enable-filter=aexciter \
	--enable-filter=amplify \
	--enable-filter=apulsator \
	--enable-filter=atempo \
	--enable-filter=dialoguenhance \
	--enable-filter=rubberband \
	--enable-filter=sinc \
	--enable-filter=sine \
	--enable-filter=crossfeed \
	--enable-filter=spectrumsynth \
	--enable-filter=showwavespic \
	--enable-filter=afreqshift \
	--enable-filter=scale* \
	--enable-filter=vflip \
	--enable-filter=hflip \
	--enable-filter=overlay \
	--enable-filter=crop \
	--enable-filter=cropdetect \
	--enable-filter=format \
	--enable-filter=aformat \
	--enable-filter=noformat \
	--enable-filter=signalstats \
	--enable-filter=framepack \
	--enable-filter=framerate \
	--enable-filter=hwdownload \
	--enable-filter=hwupload \
	\
	--disable-protocols \
	--disable-protocol=ffrtmphttp \
	--disable-protocol=rtmp \
	--disable-protocol=rtmps \
	--disable-protocol=rtmpt \
	--disable-protocol=rtmpts \
	--disable-protocol=rtp \
	--disable-protocol=srtp \
	--disable-protocol=libsrt \
	--disable-protocol=libssh \
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
	--enable-protocol=udp \
	\
	--disable-encoders \
	--enable-encoder=mjpeg \
	--enable-encoder=ljpeg \
	--enable-encoder=jpegls \
	--enable-encoder=jpeg2000 \
	--enable-encoder=apng \
	--enable-encoder=bmp \
	--enable-encoder=dpx \
	--enable-encoder=exr \
	--enable-encoder=gif \
	--enable-encoder=png \
	--enable-encoder=pam \
	--enable-encoder=pbm \
	--enable-encoder=pcx \
	--enable-encoder=pfm \
	--enable-encoder=pgm \
	--enable-encoder=pgmyuv \
	--enable-encoder=phm \
	--enable-encoder=png \
	--enable-encoder=ppm \
	--enable-encoder=fits \
	--enable-encoder=tiff \
	--enable-encoder=qoi \
	--enable-encoder=sgi \
	--enable-encoder=sunrast \
	--enable-encoder=targa \
	--enable-encoder=xbm \
	--enable-encoder=xwd \
	--enable-encoder=yuv4 \
	--enable-encoder=wbmp \
	--enable-encoder=libwebp \
	--enable-encoder=libwebp_anim \
	\
	--enable-network \
	--disable-libmfx \
	--disable-avisynth \
	--disable-vapoursynth \
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
	--enable-iconv \
	--enable-libmysofa \
	--enable-libjxl \
	--enable-libplacebo \
	--enable-libshaderc \
	--disable-libdavs2 \
	--disable-libuavs3d \
	\
	--disable-libfontconfig \

# - 报错找不到依赖包时，也可能是 configure 尝试使用依赖库编译测试程序失败：
# 	- 其中可能是 cpu平台不正确、符号缺失、缺少 include搜索目录或链接搜索目录、缺少指定链接库名称等原因

make -j$cores
make DESTDIR="$prefix_dir" install

echo "$(ls -lh $prefix_dir/lib/libav*)"