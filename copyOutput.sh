rm -rf ./output/
mkdir output
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/output/default-arm64-v8a.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/output/default-armeabi-v7a.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/output/default-x86.jar ./output/
docker cp 8f15:/home/coolight/program/media/libmpv-android-video-build/output/default-x86_64.jar ./output/
