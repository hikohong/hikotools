#!/bin/bash
function show_usage()
{
    echo "============================================"
    echo "  backup imx179 driver and tuning process"
    echo "  1st parm for file name"
    echo "      ./bk_imx179.sh [filename]"
    echo "============================================"
}

IMG_CACHE="img_cache"
FILENAME="backup_imx179.tar.bz2"

if [ $1 ]; then
        IMG_CACHE="$1"
        FILENAME="$1".tar.bz2
else
    show_usage
    exit 1
fi

if [ -d $IMG_CACHE ]; then
    rm -rf $IMG_CACHE
    fi

mkdir $IMG_CACHE
echo "image cache folder created!"

cp "/home/hikohong/Android/unifi-frontrow_RIGA_r17_sync/vendor/qcom/proprietary/mm-camera/mm-camera2/media-controller/modules/sensors/configs/imx179_chromatix.xml" $IMG_CACHE/

cp -R "/home/hikohong/Android/unifi-frontrow_RIGA_r17_sync/vendor/qcom/proprietary/mm-camera/mm-camera2/media-controller/modules/sensors/sensor/libs/imx179" $IMG_CACHE/

cp -R "/home/hikohong/Android/unifi-frontrow_RIGA_r17_sync/vendor/qcom/proprietary/mm-camera/mm-camera2/media-controller/modules/sensors/sensor/module" $IMG_CACHE/

cp -R "/home/hikohong/Android/unifi-frontrow_RIGA_r17_sync/vendor/qcom/proprietary/mm-camera/mm-camera2/media-controller/modules/sensors/chromatix/0309/chromatix_imx179" $IMG_CACHE/


tar jcvf $FILENAME $IMG_CACHE/

rm -rf $IMG_CACHE



