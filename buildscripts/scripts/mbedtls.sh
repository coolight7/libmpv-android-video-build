#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	make clean
	exit 0
else
	exit 255
fi

$0 clean # separate building not supported, always clean

make CFLAGS="-fPIC -mpclmul -msse2 -maes" CXXFLAGS=-fPIC -j$cores no_test
make CFLAGS="-fPIC -mpclmul -msse2 -maes" CXXFLAGS=-fPIC DESTDIR="$prefix_dir" install
