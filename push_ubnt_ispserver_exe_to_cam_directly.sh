#!/bin/bash
BUILD_TYPE=gen3m
IP_ADDR_CAM=10.2.128.167
G2_ISPSERVER_CODE_PATH=/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/packages-other/ubnt-middleware/unifi-video-fw-middleware/builders/cmake/output/gen2/MinSizeRel/STATIC/rootfs/usr/bin/ubnt_ispserver
G3L_ISPSERVER_CODE_PATH=/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/packages-other/ubnt-middleware/unifi-video-fw-middleware/builders/cmake/output/gen3l/MinSizeRel/STATIC/rootfs/usr/bin/ubnt_ispserver
G3M_ISPSERVER_CODE_PATH=/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/packages-other/ubnt-middleware/unifi-video-fw-middleware/builders/cmake/output/gen3m/MinSizeRel/STATIC/rootfs/usr/bin/ubnt_ispserver
ISPSERVER_CODE_PATH=$G3M_ISPSERVER_CODE_PATH
CMAKE_DIR=/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/packages-other/ubnt-middleware/unifi-video-fw-middleware
if [ $1 ]; then
    IP_ADDR_CAM=$2
    if [ $2 ]; then
       case $2 in
           gen2)
               BUILD_TYPE=$2
               ISPSERVER_CODE_PATH=$G2_ISPSERVER_CODE_PATH
           ;;
           gen3l)
               BUILD_TYPE=$2
               ISPSERVER_CODE_PATH=$G3L_ISPSERVER_CODE_PATH
           ;;
           gen3m)
               BUILD_TYPE=$2
               ISPSERVER_CODE_PATH=$G3M_ISPSERVER_CODE_PATH
           ;;
           *)
               BUILD_TYPE=gen3m
               ISPSERVER_CODE_PATH=$G3M_ISPSERVER_CODE_PATH
           ;;
       esac
    fi
#else
#    show_usage
#    exit 1
fi

echo "building $BUILD_TYPE middleware exe"
#cd "/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/openwrt-gen3m-dbg/"
#make package/ubnt-middleware/compile V=99
cd $CMAKE_DIR
./builders/cmake/utils/compile -p $BUILD_TYPE

echo "scp ubnt_ispserver into cam $IP_ADDR_CAM"
sshpass -p ubnt scp $ISPSERVER_CODE_PATH  ubnt@$IP_ADDR_CAM:/tmp/ubnt_ispserver_tmp

echo "install ubnt_ispserver in camera"
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "sed -i \"s/null::respawn:\/bin\/ubnt_ispserver/null::respawn:\/tmp\/ubnt_ispserver_tmp/\" /etc/inittab"

echo "install ubnt_ispserver_tmp"
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "kill -1 1 && killall ubnt_ispserver"
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "cp /tmp/ubnt_ispserver_tmp /tmp/ubnt_ispserver"
sleep 3
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "sed -i \"s/null::respawn:\/bin\/ubnt_ispserver_tmp/null::respawn:\/tmp\/ubnt_ispserver/\" /etc/inittab"

echo "install ubnt_ispserver"
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "kill -1 1 && killall ubnt_ispserver_tmp"
sleep 3
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM "rm /tmp/ubnt_ispserver_tmp"
#echo "reboot camera"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM reboot

#echo "getting camera log"
#rm ./out
#sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM logread > /tmp/out
