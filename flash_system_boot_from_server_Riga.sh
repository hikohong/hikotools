#!/bin/bash
#TPE_R12
#ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_sync/snapdragon-high-med-2016-spf-1-0_amss_standard_oem/LA.UM.5.3/LINUX/android/out/target/product/frontrow_wear"
#Riga_R14
#ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_RIGA_r12_sync/out/target/product/frontrow_wear"
#Riga_R17
ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_RIGA_r17_sync/out/target/product/frontrow_wear"


IMG_CACHE="img_cache"
if [ -d $IMG_CACHE ]; then
	rm -rf $IMG_CACHE
fi
mkdir $IMG_CACHE

./adb_Mac root
./adb_Mac reboot bootloader


scp -P 8788 $ANDROID_IMG_DIR/boot.img $IMG_CACHE
./fastboot_Mac flash boot $IMG_CACHE/boot.img

scp -P 8788 $ANDROID_IMG_DIR/system.img $IMG_CACHE
./fastboot_Mac flash system $IMG_CACHE/system.img

scp -P 8788 $ANDROID_IMG_DIR/emmc_appsboot.mbn $IMG_CACHE
./fastboot_Mac flash aboot $IMG_CACHE/emmc_appsboot.mbn

scp -P 8788 $ANDROID_IMG_DIR/cache.img $IMG_CACHE
./fastboot_Mac flash cache $IMG_CACHE/cache.img

scp -P 8788 $ANDROID_IMG_DIR/userdata.img $IMG_CACHE
./fastboot_Mac flash userdata $IMG_CACHE/userdata.img


./fastboot_Mac reboot

rm -rf $IMG_CACHE

