#!/bin/bash
DES_PATH=.
IP_ADDR_VAULT=192.168.1.10
IP_ADDR_CAM=172.30.0.165
if [ $1 ]; then
    DES_PATH=$1
    if [ $2 ]; then
        IP_ADDR_VAULT=$2
        if [ $3 ]; then
            IP_ADDR_CAM=$3
        fi
    fi
#else
#    show_usage
#    exit 1
fi

echo "getting camera $IP_ADDR_CAM snapshot through vault $IP_ADDR"
#sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT "rm /tmp/snap.jpeg"
sshpass -p ubnt ssh ubnt@$IP_ADDR_VAULT "rm/tmp/snap.jpeg ; sshpass -p ubnt scp ubnt@$IP_ADDR_CAM:/tmp/snap.jpeg > /tmp/"
rm $DES_PATH/snap.jpeg ; sshpass -p ubnt scp ubnt@$IP_ADDR_VAULT:/tmp/snap.jpeg $DES_PATH
