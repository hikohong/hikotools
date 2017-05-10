#!/bin/bash
#IP_ADDR_CAM=10.2.129.16
IP_ADDR_CAM=10.2.128.104
#IP_ADDR_CAM=10.2.129.49
#IP_ADDR_CAM=10.2.129.88
#IP_ADDR_CAM=10.2.129.206
if [ $1 ]; then
    IP_ADDR_CAM=$1
#else
#    show_usage
#    exit 1
fi

echo "building package"
make package/ubnt-middleware/compile V=99
echo "updating to $IP_ADDR_CAM"
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM 'mount -o rw,remount /'
#sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM 'kill -1 1'
#sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM 'pkill ubnt_ispserver'
#sshpass -p ubnt scp openwrt-gen3m-dbg/build_dir/target-arm-openwrt-linux-uclibcgnueabi/ubnt-middleware/ipkg-ambarella/ubnt-middleware/usr/lib/libubnt_ispserver_*  ubnt@$IP_ADDR_CAM:/lib/
sshpass -p ubnt scp build_dir/target-arm-openwrt-linux-uclibcgnueabi/ubnt-middleware/ipkg-ambarella/ubnt-middleware/usr/lib/libubnt_ispserver_*  ubnt@$IP_ADDR_CAM:/lib/
#sshpass -p ubnt scp build_dir/target-arm-openwrt-linux-uclibcgnueabi/ubnt-middleware/ipkg-ambarella/ubnt-middleware/usr/bin/ubnt_ispserver  ubnt@$IP_ADDR_CAM:/bin/
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM reboot
