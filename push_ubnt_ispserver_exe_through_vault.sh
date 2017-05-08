#!/bin/bash
IP_ADDR_VAULT=10.2.128.51
IP_ADDR_CAM=172.30.0.165
if [ $1 ]; then
    $IP_ADDR_VAULT=$1
    $IP_ADDR_CAM=$2
#else
#    show_usage
#    exit 1
fi

echo "building ubnt_ispserver exe"
#cd "/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/openwrt-gen3m-dbg/"
#make package/ubnt-middleware/compile V=99
cd "/home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/openwrt-gen3m-dbg/package/ubnt-middleware/unifi-video-fw-middleware"
./builders/cmake/utils/compile -p gen3m

echo "updating to vault $IP_ADDR_VAULT"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'mount -o rw,remount /'

echo "scp ubnt_ispserver into vault"
sshpass -p ubnt scp /home/hikohong/Android/unifi-video-fw_sync/unifi-video-firmware/packages-other/ubnt-middleware/unifi-video-fw-middleware/builders/cmake/output/gen3m/MinSizeRel/STATIC/rootfs/usr/bin/ubnt_ispserver  ubnt@$IP_ADDR_VAULT:/tmp/

echo "scp ubnt_ispserver from vault to cam"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt scp /tmp/ubnt_ispserver ubnt@172.30.0.165:/tmp/'
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt scp /tmp/ubnt_ispserver ubnt@172.30.0.165:/tmp/ubnt_ispserver_tmp'

#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt scp /tmp/ubnt_ispserver ubnt@$IP_ADDR_CAM:/tmp/'
echo "install ubnt_ispserver in camera"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "sed -i \"s/null::respawn:\/bin\/ubnt_ispserver/null::respawn:\/tmp\/ubnt_ispserver_tmp/\" /etc/inittab"'
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "kill -1 1 && killall ubnt_ispserver && /tmp/ubnt_ispserver &"'
echo "install ubnt_ispserver_tmp"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "kill -1 1 && killall ubnt_ispserver"'
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "cp /tmp/ubnt_ispserver_tmp /tmp/ubnt_ispserver"'
sleep 3
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "sed -i \"s/null::respawn:\/bin\/ubnt_ispserver_tmp/null::respawn:\/tmp\/ubnt_ispserver/\" /etc/inittab"'
echo "install ubnt_ispserver"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "kill -1 1 && killall ubnt_ispserver_tmp"'
sleep 3
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 "rm /tmp/ubnt_ispserver_tmp"'
#echo "reboot camera"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'sshpass -p ubnt ssh ubnt@172.30.0.165 reboot'

#echo "getting camera log"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT 'rm /tmp/out && sshpass -p ubnt ssh ubnt@172.30.0.165 logread > /tmp/out'
#sshpass -p ubnt scp ubnt@$IP_ADDR_VAULT:/tmp/out .
