#!/bin/bash
IP_ADDR_VAULT=192.168.1.10
IP_ADDR_CAM=172.30.0.165
if [ $1 ]; then
    $IP_ADDR_VAULT=$1
    if [ $1 ]; then
        $IP_ADDR_CAM=$2
    fi
#else
#    show_usage
#    exit 1
fi

echo "getting camera $IP_ADDR_CAM log through vault $IP_ADDR"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT "rm /tmp/out"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT "sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM logread > /tmp/out"
rm ./out
sshpass -p ubnt scp ubnt@$IP_ADDR_VAULT:/tmp/out .
