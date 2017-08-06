#!/bin/bash
IP_ADDR_CAM=10.2.128.167
if [ $1 ]; then
    IP_ADDR_CAM=$1
#else
#    show_usage
#    exit 1
fi

echo "getting camera $IP_ADDR_CAM log"
rm ./out
sshpass -p ubnt ssh ubnt@$IP_ADDR_CAM logread > ./out
