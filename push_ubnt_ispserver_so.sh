#!/bin/bash
IP_ADDR=10.2.129.16
#IP_ADDR=10.2.129.206
if [ $1 ]; then
    $IP_ADDR=$1
#else
#    show_usage
#    exit 1
fi

echo "building package"
make package/ubnt-middleware/compile V=99
echo "updating to $IP_ADDR"
sshpass -p ubnt ssh ubnt@$IP_ADDR 'mount -o rw,remount /'
#sshpass -p ubnt scp openwrt-gen3m-dbg/build_dir/target-arm-openwrt-linux-uclibcgnueabi/ubnt-middleware/ipkg-ambarella/ubnt-middleware/usr/lib/libubnt_ispserver_*  ubnt@$IP_ADDR:/lib/
sshpass -p ubnt scp build_dir/target-arm-openwrt-linux-uclibcgnueabi/ubnt-middleware/ipkg-ambarella/ubnt-middleware/usr/lib/libubnt_ispserver_*  ubnt@$IP_ADDR:/lib/
sshpass -p ubnt ssh ubnt@$IP_ADDR reboot
