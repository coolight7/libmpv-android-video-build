# --------------------------------------------------

export build_home_dir="$PWD/../"

# TODO: coolight --- temp
# if [ ! -f "deps" ]; then
#   sudo rm -rf deps
# fi
# if [ ! -f "prefix" ]; then
#   sudo rm -rf prefix
# fi

# ./download.sh
# ./patch.sh

# --------------------------------------------------

if [ ! -f "scripts/ffmpeg" ]; then
  rm scripts/ffmpeg.sh
fi
cp flavors/default.sh scripts/ffmpeg.sh

# --------------------------------------------------

# coolight --- temp
# ./build.sh
./build.sh --prebuild-rm-ff-mpv

if [ $? -ne 0 ]; then
  exit -1
fi

"./sdk/android-sdk-linux/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip" --strip-all prefix/arm64-v8a/usr/local/lib/libmpv.so
"./sdk/android-sdk-linux/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip" --strip-all prefix/armeabi-v7a/usr/local/lib/libmpv.so
"./sdk/android-sdk-linux/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip" --strip-all prefix/x86/usr/local/lib/libmpv.so
"./sdk/android-sdk-linux/ndk/27.3.13750724/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip" --strip-all prefix/x86_64/usr/local/lib/libmpv.so

# --------------------------------------------------

cd deps/media-kit-android-helper
rm -rf app/build/

# 改为带后缀的动态库，以便打包时和 ffmpeg-kit 共存区分
# 且复制带后缀的库去掉后缀可以给 ffmpeg-kit 共用，但打包压缩时会解压为两个不同名的库文件，避免进程内不同模块加载两次so库后干扰

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp ../../prefix/arm64-v8a/usr/local/lib/libmpv.so      app/build/outputs/apk/release/lib/arm64-v8a
cp ../../prefix/arm64-v8a/usr/local/lib/libswresample.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libavutil.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libavcodec.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libavformat.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libswscale.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libavfilter.so      app/build/outputs/apk/release/lib/arm64-v8a/
cp ../../prefix/arm64-v8a/usr/local/lib/libavdevice.so      app/build/outputs/apk/release/lib/arm64-v8a/

cp ../../prefix/armeabi-v7a/usr/local/lib/libmpv.so    app/build/outputs/apk/release/lib/armeabi-v7a
cp ../../prefix/armeabi-v7a/usr/local/lib/libswresample.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libavutil.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libavcodec.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libavformat.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libswscale.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libavfilter.so      app/build/outputs/apk/release/lib/armeabi-v7a/
cp ../../prefix/armeabi-v7a/usr/local/lib/libavdevice.so      app/build/outputs/apk/release/lib/armeabi-v7a/

cp ../../prefix/x86/usr/local/lib/libmpv.so            app/build/outputs/apk/release/lib/x86
cp ../../prefix/x86/usr/local/lib/libswresample.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libavutil.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libavcodec.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libavformat.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libswscale.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libavfilter.so      app/build/outputs/apk/release/lib/x86/
cp ../../prefix/x86/usr/local/lib/libavdevice.so      app/build/outputs/apk/release/lib/x86/

cp ../../prefix/x86_64/usr/local/lib/libmpv.so         app/build/outputs/apk/release/lib/x86_64
cp ../../prefix/x86_64/usr/local/lib/libswresample.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libavutil.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libavcodec.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libavformat.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libswscale.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libavfilter.so      app/build/outputs/apk/release/lib/x86_64/
cp ../../prefix/x86_64/usr/local/lib/libavdevice.so      app/build/outputs/apk/release/lib/x86_64/

cd app/build/outputs/apk/release

rm -rf $build_home_dir/output/
mkdir -p $build_home_dir/output/

resetSONAME() {
  if [[ $1 != "arm64-v8a" && $1 != "armeabi-v7a" && $1 != "x86" && $1 != "x86_64" ]]; then
    echo "call resetSONAME 参数 {cpu} 不正确: $1"
    exit -1
  fi

  mkdir -p $build_home_dir/output/$1/
  cp lib/$1/lib*.so       $build_home_dir/output/$1/
  zip -r default-$1.jar      lib/$1/lib*.so
  cp default-$1.jar       $build_home_dir/output/

  # 查看 SONAME NEEDED : readelf -d 
  cd lib/$1/
  cp libavcodec.so libxxcodec.so
  patchelf --set-soname libxxcodec.so libxxcodec.so
  patchelf --replace-needed libswresample.so libxxresample.so libxxcodec.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxcodec.so
  cp libavdevice.so libxxdevice.so
  patchelf --set-soname libxxdevice.so libxxdevice.so
  patchelf --replace-needed libavformat.so libxxformat.so libxxdevice.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxdevice.so
  cp libavfilter.so libxxfilter.so
  patchelf --set-soname libxxfilter.so libxxfilter.so
  patchelf --replace-needed libswresample.so libxxresample.so libxxfilter.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxfilter.so
  cp libavformat.so libxxformat.so
  patchelf --set-soname libxxformat.so libxxformat.so
  patchelf --replace-needed libavcodec.so libxxcodec.so libxxformat.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxformat.so
  cp libavutil.so libxxutil.so
  patchelf --set-soname libxxutil.so libxxutil.so
  cp libswresample.so libxxresample.so
  patchelf --set-soname libxxresample.so libxxresample.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxresample.so
  cp libswscale.so libxxscale.so
  patchelf --set-soname libxxscale.so libxxscale.so
  patchelf --replace-needed libavutil.so libxxutil.so libxxscale.so
  patchelf --replace-needed libavcodec.so libxxcodec.so libmpv.so
  patchelf --replace-needed libswresample.so libxxresample.so libmpv.so
  patchelf --replace-needed libavutil.so libxxutil.so libmpv.so
  patchelf --replace-needed libavfilter.so libxxfilter.so libmpv.so
  patchelf --replace-needed libavformat.so libxxformat.so libmpv.so
  patchelf --replace-needed libswscale.so libxxscale.so libmpv.so
  patchelf --replace-needed libavdevice.so libxxdevice.so libmpv.so
  cd ../../
  zip -r rename-$1.jar      lib/$1/lib*.so
  cp rename-$1.jar       $build_home_dir/output/
}

resetSONAME arm64-v8a
resetSONAME armeabi-v7a
resetSONAME x86
resetSONAME x86_64

md5sum *.jar

echo "current dir: vvvvvvvvvvvvvvvvvvvv"
pwd

echo "target dir: vvvvvvvvvvvvvvvvvvvv"
echo $build_home_dir/output/