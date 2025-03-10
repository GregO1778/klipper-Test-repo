#!/bin/bash

MAINDIR=$PWD
mkdir -p ./dl 
cd dl

#wget --no-parent -nd -cr --show-progress https://klipper.cxswyjy.com/download/sonic_dl/

cd $MAINDIR

echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"
echo "**** Cleanup previous builds                                               ****"
echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"

rm -rf ./.config
rm -rf ./.config.old
rm -rf ./out/
rm -rf ./tmp/
rm -rf ./logs/
rm ./lichee/arisc/.config ./lichee/arisc/ar100s/driver/intc/.intc.o.d ./lichee/arisc/ar100s/driver/intc/.intc.o.tmp
rm ./lichee/arisc/ar100s/tools/.toolchain.flag ./lichee/arisc/ar100s/tools/toolchain.tar.bz2 ./lichee/arisc/coco/coco/tools/d10_toolchain.tar.bz2
rm ./lichee/arisc/coco/coco/tools/openrisc_toolchain.tar.bz2 ./lichee/brandy-2.0/spl/.newest-33c564d739c49d7b4b006da2c6e9c05e.patch
rm ./lichee/brandy-2.0/tools/toolchain/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabi.tar.xz ./lichee/brandy-2.0/tools/toolchain/riscv64-linux-x86_64-20200528.tar.xz
rm ./package/cortana/cortana-sdk/libs/libskype_call.so


echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"
echo "**** Prepare build process                                                 ****"
echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"

./scripts/prepare.sh

[ $? -ne 0 ] && (>&2 echo "Error found executing prepare script!"; exit 1)

echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"
echo "**** Building OS                                                           ****"
echo "**** ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ****"

source build/envsetup.sh
lunch 6
make clean FORCE=1
make -j2 && pack
swupdate_pack_swu -ab