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
[[ "$ndk_triple" == "aarch64"* ]] && cpu=armv8-a
[[ "$ndk_triple" == "x86_64"* ]] && cpu=generic
[[ "$ndk_triple" == "i686"* ]] && cpu="i686 --disable-asm"

cpuflags=
[[ "$ndk_triple" == "arm"* ]] && cpuflags="$cpuflags -mfpu=neon -mcpu=cortex-a8"

../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- --ar=$AR --cc=$CC --ranlib=$RANLIB \
	--arch=${ndk_triple%%-*} --cpu=$cpu --pkg-config=pkg-config --nm=llvm-nm \
	--extra-cflags="-I$prefix_dir/include $cpuflags" --extra-ldflags="-L$prefix_dir/lib" \
	--pkg-config-flags=--static \
	\
	--disable-gpl \
	--disable-nonfree \
	--enable-version3 \
	\
    --disable-debug \
	--disable-shared \
	--enable-static \
	--disable-stripping \
	--enable-runtime-cpudetect \
	--enable-small \
	--enable-hwaccels \
	--enable-optimizations \
	\
	--disable-vulkan \
	--disable-iconv \
	\
	--disable-muxers \
	--disable-decoders \
	--disable-encoders \
	--disable-demuxers \
	--disable-parsers \
	--disable-protocols \
	--disable-devices \
	--disable-filters \
	--disable-avdevice \
	--disable-doc \
	--disable-programs \
	--disable-ffmpeg \
	--disable-ffprobe \
	--disable-swscale-alpha \
	--disable-gray \
	--disable-postproc \
	\
	--enable-jni \
	--enable-mediacodec \
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vdpau \
	--disable-bzlib \
	--disable-linux-perf \
	--disable-videotoolbox \
	--disable-audiotoolbox \
	\
	--enable-avutil \
	--enable-avcodec \
	--enable-avfilter \
	--enable-avformat \
	--enable-swscale \
	--enable-swresample \
	\
	--enable-bsfs \
	--disable-bsf=mov2textsub \
	--disable-bsf=text2movsub \
	\
	--enable-decoders \
	--enable-decoder=aac_mediacodec \
	--enable-decoder=amrnb_mediacodec \
	--enable-decoder=amrwb_mediacodec \
	--enable-decoder=h264_mediacodec \
	--enable-decoder=hevc_mediacodec \
	--enable-decoder=mp3_mediacodec \
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
	--disable-decoder=libaom_av1 \
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
	\
	--enable-filter=thumbnail \
	--enable-filter=thumbnail_cuda \
	--disable-filter=movie \
	\
	--disable-filter=avsynctest \
	--disable-filter=fsync \
	--enable-filter=metadata \
	--enable-filter=null \
	--enable-filter=nullsink \
	--enable-filter=nullsrc \
	--disable-filter=realtime \

	--enable-filter=acopy \
	--enable-filter=amix \
	--enable-filter=amerge \
	--disable-filter=areverse \
	--enable-filter=aresample \
	--enable-filter=asplit \
	--enable-filter=atrim \
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
	--disable-filter=adeclick \
	--disable-filter=adeclip \
	--disable-filter=afftdn \
	--disable-filter=afwtdn \
	--disable-filter=anlmdn \
	--disable-filter=arnndn \
	--disable-filter=dcshift \
	--disable-filter=deesser \
	--disable-filter=fftdnoiz \
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
	--enable-filter=spectrumsynth \
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
	--enable-protocol=libssh \
	\
	--disable-encoders \
	--enable-encoder=mjpeg \
	--disable-encoder=ljpeg \
	--disable-encoder=jpegls \
	--disable-encoder=jpeg2000 \
	--enable-encoder=png \
	--enable-encoder=bmp \
	--enable-encoder=gif \
	--enable-encoder=apng \
	--enable-encoder=tiff \
	--enable-encoder=libwebp \
	--enable-encoder=libwebp_anim \
	--disable-encoder=ppm \
	--disable-encoder=pgm \
	--disable-encoder=pcx \
	--disable-encoder=sgi \
	--disable-encoder=sunrast \
	--disable-encoder=targa \
	--enable-encoder=wbmp \
	--disable-encoder=xbm \
	--disable-encoder=xwd \
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
	--enable-amf \
	--enable-dxva2 \
	--enable-libuavs3d \
	--enable-d3d11va \
	--enable-openal \
	--enable-opengl \
	--enable-vaapi \
	--enable-libass \
	--enable-libfreetype \
	--enable-libfribidi \
	--enable-libfontconfig \
	--enable-libharfbuzz \
	--enable-libmp3lame \
	--enable-lcms2 \
	--enable-libopus \
	--enable-libsoxr \
	--enable-libspeex \
	--enable-libvorbis \
	--enable-libbs2b \
	--enable-librubberband \
	--enable-libvpx \
	--enable-libwebp \
	--enable-libaom \
	--enable-libsvtav1 \
	--enable-libdav1d \
	--enable-libzimg \
	--enable-openssl \
	--enable-libxml2 \
	--enable-iconv \
	--enable-libmysofa \
	--enable-libssh \
	--enable-libvpl \
	--enable-libjxl \
	--enable-libplacebo \
	--enable-libshaderc \
	--enable-libdavs2 \
	--enable-libuavs3d \
	--enable-lto=thin \

make -j$cores
make DESTDIR="$prefix_dir" install

ln -sf "$prefix_dir"/lib/libswresample.so "$native_dir"
ln -sf "$prefix_dir"/lib/libpostproc.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavutil.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavcodec.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavformat.so "$native_dir"
ln -sf "$prefix_dir"/lib/libswscale.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavfilter.so "$native_dir"
ln -sf "$prefix_dir"/lib/libavdevice.so "$native_dir"
