#!/bin/sh

. ./config.sh

WOWNERO_URL="https://git.wownero.com/wownero/wownero.git"
WOWNERO_VERSION=v0.11.0.1
WOWNERO_SHA_HEAD="a21819cc22587e16af00e2c3d8f70156c11310a0"
WOWNERO_SRC_DIR="${EXTERNAL_IOS_SOURCE_DIR}/wownero"

BUILD_TYPE=release
PREFIX=${EXTERNAL_IOS_DIR}
DEST_LIB_DIR=${EXTERNAL_IOS_LIB_DIR}/wownero
DEST_INCLUDE_DIR=${EXTERNAL_IOS_INCLUDE_DIR}/wownero

echo "Cloning wownero from - $WOWNERO_URL to - $WOWNERO_SRC_DIR"		
git clone ${WOWNERO_URL} ${WOWNERO_SRC_DIR} --branch ${WOWNERO_VERSION}
cd $WOWNERO_SRC_DIR
git reset --hard $WOWNERO_SHA_HEAD
git checkout $WOWNERO_VERSION
git submodule update --init --force
git apply --stat --apply ${CW_ROOT}/patches/wownero/refresh_thread.patch
mkdir -p build
cd ..

echo $DEST_LIB_DIR
mkdir -p $DEST_LIB_DIR
mkdir -p $DEST_INCLUDE_DIR

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $INSTALL_PREFIX ]; then
    INSTALL_PREFIX=${ROOT_DIR}/wownero
fi

for arch in "arm64" #"armv7" "arm64"
do

echo "Building IOS ${arch}"
export CMAKE_INCLUDE_PATH="${PREFIX}/include"
export CMAKE_LIBRARY_PATH="${PREFIX}/lib"

case $arch in
	"armv7"	)
		DEST_LIB=../../lib-armv7;;
	"arm64"	)
		DEST_LIB=../../lib-armv8-a;;
esac

rm -rf wownero/build > /dev/null

mkdir -p wownero/build/${BUILD_TYPE}
pushd wownero/build/${BUILD_TYPE}
cmake -D IOS=ON \
	-DARCH=${arch} \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DSTATIC=ON \
	-DBUILD_GUI_DEPS=ON \
	-DUNBOUND_INCLUDE_DIR=${EXTERNAL_IOS_INCLUDE_DIR} \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}  \
    -DUSE_DEVICE_TREZOR=OFF \
	../..
make wallet_api -j$(nproc) && make install
find . -path ./lib -prune -o -name '*.a' -exec cp '{}' lib \;
cp -r ./lib/* $DEST_LIB_DIR
cp src/cryptonote_basic/libcryptonote_basic.a ${DEST_LIB}
cp src/offshore/liboffshore.a ${DEST_LIB}
popd

done

#only for arm64
cp ${WOWNERO_SRC_DIR}/lib-armv8-a/* $DEST_LIB_DIR
cp ${WOWNERO_SRC_DIR}/include/wallet/api/* $DEST_INCLUDE_DIR
