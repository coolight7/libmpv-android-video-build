#!/bin/bash

lib_path=$1

cd $lib_path
back_path=$lib_path/ffmpeg-backup/

if [[ -e $back_path ]]; then
    exit 0
fi
mkdir $back_path

mv libavfilter.a     $back_path/
mv libavutil.a       $back_path/
mv libavdevice.a     $back_path/
mv libavcodec.a      $back_path/
mv libavformat.a     $back_path/
mv libswresample.a   $back_path/
mv libswscale.a      $back_path/

pkgconfig_path=$lib_path/pkgconfig/

reset () {
    cp $pkgconfig_path/$1 $back_path/
    sed -i '/^Libs: / s/^Libs:.*/Libs: -L${libdir} -lmediaxx/' $pkgconfig_path/$1
    sed -i '/^Requires\.private:/d' $pkgconfig_path/$1
}

reset 'libavcodec.pc'
reset 'libavformat.pc'
reset 'libavfilter.pc'
reset 'libavutil.pc'
reset 'libavdevice.pc'
reset 'libswresample.pc'
reset 'libswscale.pc'