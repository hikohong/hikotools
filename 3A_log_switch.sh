#!/bin/bash
#===========================================
#  Author: Hiko Hong
#===========================================

function show_usage() 
{
	echo "==================================================================================="
	echo " 3A on/off switch"
	echo " Author Hiko Hong"
	echo "   3A_log_switch [switch_option]"
	echo "   Example:"
	echo "   ./3A_log_switch.sh --all"
	echo "-----------------------------------------------------------------------------------"
	echo "[switch_option] --af --ae --awb --exif --all3a --all --off"
	echo "==================================================================================="
}


function af() 
{
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 00100
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 4
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.stats.af.debug 6
}

function ae() 
{
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 00001
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 1
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.stats.aec.debug 6
}

function awb() 
{
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 00010
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 2
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.stats.awb.debug 6
}

function exif_open()
{
	$ADB_CMD root
	$ADB_CMD remount
	$ADB_CMD shell chmod 777 /data
	$ADB_CMD shell setprop persist.camera.mobicat 2
	#this is Qualcomm's OLD setting from doc
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 3080192
	#thie is Qualcomm NEW setting from case owner Heyden (including AE AF)
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 3080197
	#this is Qualcomm Chromatix 6 User Guide's suggestion
	#$ADB_CMD shell setprop persist.camera.stats.debug 2555967
	#$ADB_CMD shell setprop persist.camera.stats.debug 2555967
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.global.debug 1
	$ADB_CMD shell setprop persist.camera.stats.debugexif 2555904
	$ADB_CMD shell sync
}

function all()
{
	$ADB_CMD root
	$ADB_CMD remount
	$ADB_CMD shell chmod 777 /data
	$ADB_CMD shell setprop persist.camera.mobicat 2
	#thie is Qualcomm NEW setting from case owner Heyden (including AE AWB AF)
	$ADB_CMD shell setprop persist.camera.stats.debug.mask 3080199
	$ADB_CMD shell sync
}

function all3a() 
{
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 00111
	# $ADB_CMD shell setprop persist.camera.stats.debug.mask 7
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.stats.af.debug 6
	$ADB_CMD shell setprop persist.camera.stats.aec.debug 6
	$ADB_CMD shell setprop persist.camera.stats.awb.debug 6
}

function off() 
{
	$ADB_CMD shell setprop persist.camera.mobicat 0
	#$ADB_CMD shell setprop persist.camera.stats.debug.mask 00000
	#following is for APQ8053 3A version 0309
	$ADB_CMD shell setprop persist.camera.stats.af.debug 0
	$ADB_CMD shell setprop persist.camera.stats.aec.debug 0
	$ADB_CMD shell setprop persist.camera.stats.awb.debug 0
    $ADB_CMD shell setprop persist.camera.stats.debugexif 0
    $ADB_CMD shell setprop persist.camera.global.debug 0
}

ADB_CMD=./adb_Mac
#################
# Main procedure
#################
$ADB_CMD root
sleep 1
$ADB_CMD remount
sleep 1

if [ "$1" == "--af" ]; then
	af
elif [ "$1" == "--ae" ]; then
	ae
elif [ "$1" == "--awb" ]; then
	awb
elif [ "$1" == "--exif" ]; then
	exif_open
elif [ "$1" == "--all3a" ]; then
	all3a
elif [ "$1" == "--all" ]; then
	all
elif [ "$1" == "--off" ]; then
	off
else
	show_usage
fi
