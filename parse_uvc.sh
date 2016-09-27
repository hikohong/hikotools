#!/bin/bash

PARSE_BK=~/parsing_bk
PARSE_PATH=$1
if [ -z "$PARSE_PATH" ]; then
	#print usage
    echo "please input the path for parsing"
    echo "parse_uvc.sh <PATH>"
	exit 1
fi

if  [ -d $PARSE_BK ]; then
    rm -rf $PARSE_BK
fi
mkdir $PARSE_BK
mv ./unifi-video-firmware/openwrt-gen* $PARSE_BK/

./parse_vim.sh $PARSE_PATH --rdb

mv $PARSE_BK/openwrt-gen* ./unifi-video-firmware/


