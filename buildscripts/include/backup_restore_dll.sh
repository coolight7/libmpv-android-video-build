#!/bin/bash

lib_path=$1

cd $lib_path

back_path=$lib_path/ffmpeg-backup/

if [[ ! -e $back_path ]]; then
    exit 0
fi

mv libavfilter.so*      $back_path/
mv libavutil.so*        $back_path/
mv libavdevice.so*      $back_path/
mv libavcodec.so*       $back_path/
mv libavformat.so*      $back_path/
mv libswresample.so*    $back_path/
mv libswscale.so*       $back_path/

cp $back_path/libavfilter.a     ./
cp $back_path/libavutil.a       ./
cp $back_path/libavdevice.a     ./
cp $back_path/libavcodec.a      ./
cp $back_path/libavformat.a     ./
cp $back_path/libswresample.a   ./
cp $back_path/libswscale.a      ./

pkgconfig_path=$lib_path/pkgconfig/

reset () {
    if [[ -e $back_path/$1 ]]; then
        rm $pkgconfig_path/$1
        cp $back_path/$1 $pkgconfig_path/
    fi
}

reset 'libavcodec.pc'
reset 'libavformat.pc'
reset 'libavfilter.pc'
reset 'libavutil.pc'
reset 'libavdevice.pc'
reset 'libswresample.pc'
reset 'libswscale.pc'