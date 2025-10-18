rm -rf ./output/
mkdir output
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/buildscripts/deps/media-kit-android-helper/app/build/outputs/apk/release/default-arm64-v8a.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/buildscripts/deps/media-kit-android-helper/app/build/outputs/apk/release/default-armeabi-v7a.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/buildscripts/deps/media-kit-android-helper/app/build/outputs/apk/release/default-x86.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/buildscripts/deps/media-kit-android-helper/app/build/outputs/apk/release/default-x86_64.jar ./output/
