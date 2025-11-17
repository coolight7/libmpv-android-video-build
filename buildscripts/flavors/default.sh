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
# 链接c++标准库时，如果需要静态链接
# --extra-ldflags="-L$prefix_dir/lib -lm -nostdlib++ -lc++_static -lc++abi"
# [vulkan] 会增加 5mb 左右的大小，但可能对ffmpeg用处不大
# --enable-small 如果不缩减体积，可启用 --enable-hardcoded-tables
../configure \
	--target-os=android --enable-cross-compile --cross-prefix=$ndk_triple- \
	--arch=${ndk_triple%%-*} --cpu=$cpu \
	--nm=llvm-nm --strip=llvm-strip --ranlib=$RANLIB --ar=$AR --cc=$CC --cxx=$CXX \
	--pkg-config=pkg-config \
	--stdc=c23 --stdcxx=c++23 \
  	--sysroot="${ANDROID_SYSROOT}" \
	--extra-cflags="$CFLAGS -fPIC -Wno-error=int-conversion -Wno-error=incompatible-function-pointer-types -I$prefix_dir/include $cpuflags" \
	--extra-cxxflags="$CXXFLAGS -fPIC -I$prefix_dir/include $cpuflags" \
	--extra-ldflags="$LDFLAGS -L$prefix_dir/lib $default_ld_cxx_stdlib -lm" \
	--pkg-config-flags=--static \
	\
	--enable-gpl \
	--enable-nonfree \
	--enable-version3 \
	\
    --disable-debug \
	--disable-shared \
	--enable-static \
	--enable-stripping \
	--enable-runtime-cpudetect \
	--enable-pic \
	--enable-lto=full \
	--enable-hardcoded-tables \
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
	--disable-libmysofa \
	--disable-libplacebo \
	--disable-libshaderc \
	--disable-libdavs2 \
	--disable-libuavs3d \
	--disable-libfontconfig \
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
	--enable-libjxl \
	--enable-iconv \
	--enable-zlib \
	--enable-bzlib \
	--enable-lzma \
	\
	--disable-d3d11va \
	--disable-dxva2 \
	--disable-vaapi \
	--disable-vdpau \
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
	--enable-hwaccels \
	\
	--disable-indevs \
	--disable-outdevs \
	--enable-indev=lavfi \
	\
	--disable-bsfs \
	--enable-bsf=aac_adtstoasc,chomp,dca_core,dovi_rpu,dts2pts,dump_extradata,dv_error_marker,eac3_core,evc_frame_merge,extract_extradata,filter_units,h264_mp4toannexb,h264_redundant_pps,hapqa_extract,hevc_mp4toannexb,imx_dump_header,mjpeg2jpeg,mjpega_dump_header,mpeg4_unpack_bframes,null,pcm_rechunk,remove_extradata,setts,showinfo,truehd_core \
	\
    --enable-parsers \
    --disable-parser=cook,dvdsub,dvbsub,dvd_nav,g723_1,xma,sipr,bmp,adx \
	\
	--disable-encoders \
    --enable-encoder=mjpeg,mjpeg_*,anull,vnull \
	\
	--disable-decoders \
	--enable-decoder=*_mediacodec \
	--enable-decoder=aac*,ac3*,acelp_*,alac,als,amrnb,amrwb,amv,ansi,anull,ape,apng,atrac*,av1,av1_*,avrn,avrp,avs,avui,bitpacked,bmv_audio,cavs,cbd2_dpcm,cfhd,clearvideo,cljr,cyuv,dca,dds,derf_dpcm,dfpwm,dirac,dnxhd,dolby_e,dpx,dsd_*,dsicinaudio,dsicinvideo,dss_sp,dst,dvaudio,dvvideo,dxtory,dxv,eac3,eacmv,eamad,eatgq,eatgv,eatqi,eightbps,eightsvx_exp,eightsvx_fib,escape124,escape130,evrc,exr,fastaudio,ffv1,ffvhuff,ffwavesynth,fic,fits,flac,flashsv,flashsv2,flv,fmvc,fraps,frwu,ftr,g2m,g729,gdv,gif,gremlin_dpcm,h261,h263*,h264*,hap,hdr,hevc*,hnm4_video,hq_hqa,hqx,huffyuv,hymt,iac,idf,iff_ilbm,ilbc,imc,imm4,imm5,interplay_acm,interplay_dpcm,interplay_video,jpeg2000,jpegls,jv,kgv1,kmvc,lagarith,lead,libdav1d,libdavs2,libjxl*,libopus,libuavs3d,libvorbis,libvpx*,loco,lscr,m101,mace3,mace6,magicyuv,media100,metasound,misc4,mjpeg*,mlp,mmvideo,mobiclip,motionpixels,mp1*,mp2*,mp3*,mpc*,mpeg*,mpl2,msa1,mscc,msmpeg*,msnsiren,msp2,msrle,mss*,msvideo1,mszh,mts2,mv30,mvc1,mvc2,mvdv,mvha,mwsc,mxpeg,notchlc,nuv,on2avc,opus,osq,paf_audio,paf_video,pam,pbm,pcm_*,pcx,pdv,pfm,pgm,pgmyuv,pgx,phm,photocd,pictor,pixlet,pjs,png,ppm,prores,prores_raw,prosumer,ptx,qcelp,qdraw,qoa,qoi,qpeg,qtrle,r10k,r210,ra_144,ra_288,ralf,rasc,rawvideo,rka,rl2,roq,rpza,rscc,rtv1,rv*,s302m,sanm,sbc,scpr,screenpresso,sdx2_dpcm,sga,sgi,sgirle,sheervideo,simbiosis_imx,siren,smackaud,smc,smvjpeg,snow,sonic,sp5x,speedhq,speex,srgc,sunrast,svq1,svq3,tak,targa,targa_y216,tdsc,text,theora,tiff,truehd,truemotion1,truemotion2,truemotion2rt,tscc,tscc2,tta,twinvq,ulti,utvideo,vb,vble,vbn,vc1*,vmdaudio,vmdvideo,vmix,vnull,vorbis,vp*,vqc,vvc*,wady_dpcm,wavarc,wavpack,wbmp,wcmv,webp,wmalossless,wmapro,wmav*,wmv*,wnv1,wrapped_avframe,xbin,xbm,xface,xl,xpm,xwd,y41p,ylc,yop,yuv4,zero12v,zerocodec \
	\
	--disable-decoder=zlib,zmbv,aasc,alias_pix,agm,anm,apv,arbc,argo,bmv_video,brender_pix,cdgraphics,cdtoons,cri,cdxl,cllc,cpia,camstudio,dxa,flic,4xm,gem,hnm4video,interplayvideo,mdec,mimic,psd,rasc.rl2,roqvideo,txd,vmnc,asv1,asv2,aura,aura2 \
    --disable-decoder=8svx_exp,8svx_fib,hca,hcom,interplayacm,xma1,xma2,cook \
	\
	--disable-muxers \
    --enable-muxer=image2*,mjpeg,null \
	\
	--disable-demuxers \
	--enable-demuxer=aa,aac,aax,ac3,ac4,aiff,alp,afx,amr,amrnb,amrwb,apac,ape,apm,apng,apv,argo_asf,argo_brp,argo_cvg,asf,asf_o,ast,au,av1,avi,avr,avs,avs2,avs3,bintext,bit,bitpacked,caf,cavsvideo,cdg,cine,concat,dash,data,daud,derf,dfpwm,dirac,dnxhd,dsf,dsicin,dss,dts,dtshd,dv,eac3,evc,ffmetadata,filmstrip,fits,flac,flic,flv,g722,g726,g726le,g729,gif,h261,h263,h264,hcom,hevc,hls,hnm,iamf,ico,idcin,idf,iff,ifv,ilbc,image2*,image_*,ircam,iss,iv8,ivf,jpegxl_anim,lc3,live_flv,loas,luodat,m4v,matroska,mjpeg,mjpeg_2000,mlp,mlv,mov,mp3,mpc,mpc8,mpegps,mpegts,mpegtsraw,mpegvideo,mpjpeg,mtv,mv,mvi,mxf,mxg,nc,nistsphere,nsp,nsv,nut,obu,ogg,oma,osq,paf,pcm_*,pdv,pjs,pmp,pp_bnk,pva,pvf,qcp,qoa,r3d,rawvideo,rcwt,redspark,rka,rl2,rm,rsd,rso,s337m,sap,sbc,scd,sdp,sdr2,sdx,segafilm,ser,sga,siff,simbiosis_imx,sln,smjpeg,smush,sox,spdif,sup,swf,tak,threedostr,truehd,tta,ty,vc1,vc1t,vividas,vivo,vmd,voc,vqf,vvc,w64,wady,wav,wavarc,webm_dash_manifest,wsd,wsvqa,wtv,wv,wve,xa,xbin,xmd,xmv,xwma,yop,yuv4mpegpipe \
	\
    --disable-filters \
	--enable-filter=format \
	--enable-filter=aformat \
	--enable-filter=noformat \
	--enable-filter=hwdownload \
	--enable-filter=hwupload \
	--enable-filter=copy \
	--enable-filter=showwavespic \
	--enable-filter=areverse,reverse \
	--enable-filter=silencedetect,silenceremove \
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
	--enable-filter=dialoguenhance \
	--enable-filter=equalizer \
	--enable-filter=loudnorm \
	--enable-filter=metadata \
	--enable-filter=pan \
	--enable-filter=stereowiden \
	--enable-filter=stereotools \
	--enable-filter=rubberband \
	--enable-filter=volume \
	--enable-filter=volumedetect \
	--enable-filter=null,nullsink,nullsrc,anull,anullsink,anullsrc \
	--enable-filter=amix \
	--enable-filter=aselect \
	--enable-filter=atempo \
	--enable-filter=aresample \
	--enable-filter=sinc \
	--enable-filter=sine \
	\
	--disable-protocols \
	--enable-protocol=android_content \
    --enable-protocol=async,cache,crypto,data,file,hls,pipe,http,https,httpproxy,subfile,tcp,udp,tls

# - 报错找不到依赖包时，也可能是 configure 尝试使用依赖库编译测试程序失败：
# 	- 其中可能是 cpu平台不正确、符号缺失、缺少 include搜索目录或链接搜索目录、缺少指定链接库名称等原因

make -s -j$cores
make -s DESTDIR="$prefix_dir" install > /dev/null

sed -i '/^Libs:/ s|-lstdc++|-lc++_static -lc++abi|' "$prefix_dir/lib/pkgconfig/libavfilter.pc"
echo "$(ls -lh $prefix_dir/lib/libav*)"