#!/bin/bash -e

PATCHES=(patches-encoders-gpl/*)
ROOT=$(pwd)


for dep_path in "${PATCHES[@]}"; do
    if [ -d "$dep_path" ]; then
        patches=($dep_path/*)
        dep=$(echo $dep_path |cut -d/ -f 2)
        cd deps/$dep
        echo Patching $dep
        git reset --hard
        for patch in "${patches[@]}"; do
            echo Applying $patch
            
            if [ $dep_path -eq "mpv" ]; then
                echo "------------------------------------"
                cat meson.build
                echo "------------------------------------"
            fi
            git apply "$ROOT/$patch"
        done
        cd $ROOT
    fi
done

exit 0
