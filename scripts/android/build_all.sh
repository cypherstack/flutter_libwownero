#!/bin/sh

./install_ndk.sh
./build_iconv.sh
./build_boost.sh
./build_openssl.sh
./build_unbound.sh
./build_sodium.sh
./build_zmq.sh
./build_wownero.sh
./build_wownero_seed.sh
./copy_monero_deps.sh

