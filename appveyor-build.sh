#!/bin/bash
cd "$(dirname "$0")"
pacman --noconfirm -S --needed mingw-w64-x86_64-toolchain
pacman --noconfirm -S --needed git
pacman --noconfirm -S --needed mingw-w64-x86_64-qt5-static
pacman --noconfirm -S --needed mingw-w64-x86_64-miniupnpc
pacman --noconfirm -S --needed mingw-w64-x86_64-qrencode
pacman --noconfirm -S --needed mingw-w64-x86_64-jasper
pacman --noconfirm -S --needed mingw-w64-x86_64-libevent
pacman --noconfirm -S --needed mingw-w64-x86_64-curl
wget http://esxi.z-lab.me:666/~exl_lab/software/msys2-packages.tar
tar -xf msys2-packages.tar
rm msys2-packages.tar
pacman --noconfirm -U packages/*.pkg.tar.xz
rm -Rf src/secp256k1
git clone https://github.com/bitcoin-core/secp256k1 --depth 1 -b master src/secp256k1
cd src/secp256k1
./autogen.sh
./configure --prefix=/usr/local --enable-module-recovery
make -j3
make install
cd ../../
make -j3 -C src/leveldb/ libleveldb.a libmemenv.a
/mingw64/qt5-static/bin/qmake CONFIG+=release Ferrumcoin.pro
make -j3 -f Makefile.Release
strip -s release/ferrumcoin-qt.exe
curl -sS --upload-file release/ferrumcoin-qt.exe https://transfer.sh/ferrumcoin-qt.exe && echo -e '\n'
