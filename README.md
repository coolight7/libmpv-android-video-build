## 搭建编译环境
- 本地使用 act + docker 创建容器编译
- 第一次需要下载依赖环境，修改 [bundle_default.sh](./buildscripts/bundle_default.sh) 文件内的代码解注释启用下载:
```sh
# if [ ! -f "deps" ]; then
#   sudo rm -rf deps
# fi
# if [ ! -f "prefix" ]; then
#   sudo rm -rf prefix
# fi
# 
# ./download.sh
# ./patch.sh
```
- 在真机`./build.sh`让它自动构建docker容器、下载jdk
- 后续更新编译可以进入 docker 内 `cd buildscripts && ./bundle_default.sh`

## 后续更新/修改
- 只修改了 `mediaxx` 重新编译的话，可以解注释[bundle_default.sh](./buildscripts/bundle_default.sh):
```sh
# ./build.sh --prebuild-rm-ffm-mpv-mediaxx # 清理 ffmpeg/libmpv/mediaxx 重新编译
./build.sh --prebuild-rm-mediaxx # 只清理 mediaxx 重新编译
```
- 更新了 `libmpv`、`ffmpeg` 编译:
    - 进docker，然后`cd buildscripts/deps/{ffmpeg/mpv}`，git pull 更新版本或者删除文件夹重新 git clone
    - 修改 [bundle_default.sh](./buildscripts/bundle_default.sh)，解注释`./build.sh --prebuild-rm-ffm-mpv-mediaxx`
    - `cd buildscripts && ./bundle_default.sh`编译即可
