#!/bin/bash

. ./config.sh
echo $TYPES_OF_BUILD

WORKDIR="$(pwd)/"build
CW_DIR="$(pwd)"/../../
CW_EXTERNAL_DIR=${CW_DIR}wow_cw_shared_external/ios/External/android
CW_WOWNERO_EXTERNAL_DIR=${CW_DIR}cw_wownero/ios/External/android
for arch in $TYPES_OF_BUILD
do
	PREFIX=${WORKDIR}/prefix_${arch}
	ABI=""

	case $arch in
		"aarch"	)
			ABI="armeabi-v7a";;
		"aarch64"	)
			ABI="arm64-v8a";;
		"i686"		)
			ABI="x86";;
		"x86_64"	)
			ABI="x86_64";;
	esac

	LIB_DIR=${CW_EXTERNAL_DIR}/${ABI}/lib
	INCLUDE_DIR=${CW_EXTERNAL_DIR}/${ABI}/include

	mkdir -p $LIB_DIR
	mkdir -p $INCLUDE_DIR

	cp -r ${PREFIX}/lib/* $LIB_DIR
	cp -r ${PREFIX}/include/* $INCLUDE_DIR
	cp ${PREFIX}/lib/libunbound.a ${PREFIX}/lib/wownero/libunbound.a

	mkdir -p ${CW_WOWNERO_EXTERNAL_DIR}/include

	cp $PREFIX/include/wownero/wallet2_api.h ${CW_WOWNERO_EXTERNAL_DIR}/include
done
