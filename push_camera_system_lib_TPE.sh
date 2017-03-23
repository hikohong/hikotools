#!/bin/bash

function show_usage()
{
	echo "==================================================================================="
	echo " Flash downloading processes"
	echo " Author hikohong"
	echo "   ./push_camera_system_lib.sh.sh [android_img_dir] [download_option]"
	echo "   Example:"
	echo "   ./push_camera_system_lib.sh"
	echo "   ./push_camera_system_lib.sh ANDROID_IMG_DIR"
	echo "   ./push_camera_system_lib.sh ANDROID_IMG_DIR --dv"
	echo "   ./push_camera_system_lib.sh --def --dv"
	echo "-----------------------------------------------------------------------------------"
	echo "[codebase_dir] The android image root folder"
	echo "  codebase_dir default: ./ (current location)"
	echo "[download_option] default is not set disable-verit"
	echo "  --dv to set adb disable-verit"
	echo "==================================================================================="
}






ADB_CMD=./adb_Mac
NEEDS_DISABLE_VERIT="false"

#TPE_R12
#ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_sync/snapdragon-high-med-2016-spf-1-0_amss_standard_oem/LA.UM.5.3/LINUX/android/out/target/product/frontrow_wear"
#Riga_R14
#ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_RIGA_r12_sync/out/target/product/frontrow_wear"
#Riga_R17
#ANDROID_IMG_DIR="hikohong@10.2.129.71:/media/work/Android/unifi-frontrow_RIGA_r17_sync/out/target/product/frontrow_wear"
ANDROID_IMG_DIR="hikohong@10.2.129.71:/home/hikohong/Android/unifi-frontrow_TPE_r17_sync/snapdragon-high-med-2016-spf-1-0_amss_standard_oem/LA.UM.5.3/LINUX/android/out/target/product/frontrow_wear"

if [ $1 ]; then
	if [ "$1" != "--def" ]; then
		ANDROID_IMG_DIR="$1"
	fi
else
	show_usage
	exit 1
fi

if [ $2 ]; then
	case "$2" in
		"--dv")
		NEEDS_DISABLE_VERIT="true"
		;;
	esac
fi


IMG_CACHE="img_cache"
if [ -d $IMG_CACHE ]; then
	rm -rf $IMG_CACHE
fi

mkdir $IMG_CACHE
echo "image cache folder created!"

SCP_CMD="scp -P 8788 -p"

#./adb_Mac push "$ANDROID_IMG_DIR/system/bin/mm-qcamera-daemon" /system/bin

SYSTEM_VENDOR_LIBS=(
"libmmcamera2_sensor_modules.so"
"libmmcamera2_pproc_modules.so"
"libmmcamera_tuning.so"
"libmmcamera2_imglib_modules.so"
#"libmmcamera_le2464c_eeprom.so"
#"libmmcamera_le2464c_master_eeprom.so"
#"test_suite_all_modules.so"
#"test_suite_no_sensor.so"
#"test_suite_sensor.so"

#IMX377
#"libmmcamera_imx377.so"
#"libchromatix_imx377_default_preview_lc898122.so"
#"libchromatix_imx377_common.so"
#"libchromatix_imx377_cpp_snapshot.so"
#"libchromatix_imx377_snapshot.so"
#"libchromatix_imx377_postproc.so"
##"libchromatix_imx377_4k_preview_lc898122.so"
##"libchromatix_imx377_4k_video_lc898122.so"
##"libchromatix_imx377_default_video_lc898122.so"
##"libchromatix_imx377_hdr_snapshot_lc898122.so"
##"libchromatix_imx377_hdr_video_lc898122.so"
##"libchromatix_imx377_hfr_120_lc898122.so"
##"libchromatix_imx377_hfr_60_lc898122.so" 
##"libchromatix_imx377_hfr_90_lc898122.so"
##"libchromatix_imx377_zsl_preview_lc898122.so"
##"libchromatix_imx377_zsl_video_lc898122.so"
##"libchromatix_imx377_cpp_hfr_120.so"
##"libchromatix_imx377_cpp_hfr_60.so"
##"libchromatix_imx377_cpp_hfr_90.so"
##"libchromatix_imx377_cpp_liveshot.so"
##"libchromatix_imx377_cpp_preview.so"
##"libchromatix_imx377_cpp_snapshot_hdr.so"
##"libchromatix_imx377_cpp_video.so"
##"libchromatix_imx377_cpp_video_hdr.so"
##"libchromatix_imx377_hfr_120.so"
##"libchromatix_imx377_hfr_60.so"
##"libchromatix_imx377_hfr_90.so"
##"libchromatix_imx377_preview.so"
##"libchromatix_imx377_snapshot_hdr.so"
##"libchromatix_imx377_default_video.so"
##"libchromatix_imx377_video_hdr.so"

#IMX1477
"libmmcamera_imx477.so"
"libchromatix_imx477_4k_preview_lc898122.so"
"libchromatix_imx477_4k_video_lc898122.so"
"libchromatix_imx477_default_preview_lc898122.so"
"libchromatix_imx477_default_video_lc898122.so"
"libchromatix_imx477_hdr_snapshot_lc898122.so"
"libchromatix_imx477_hdr_video_lc898122.so"
"libchromatix_imx477_hfr_120_lc898122.so"
"libchromatix_imx477_hfr_60_lc898122.so"
"libchromatix_imx477_hfr_90_lc898122.so"
"libchromatix_imx477_zsl_preview_lc898122.so"
"libchromatix_imx477_zsl_video_lc898122.so"
"libchromatix_imx477_common.so"
"libchromatix_imx477_cpp_hfr_120.so"
"libchromatix_imx477_cpp_hfr_60.so"
"libchromatix_imx477_cpp_hfr_90.so"
"libchromatix_imx477_cpp_liveshot.so"
"libchromatix_imx477_cpp_preview.so"
"libchromatix_imx477_cpp_snapshot.so"
"libchromatix_imx477_cpp_snapshot_hdr.so"
"libchromatix_imx477_cpp_video.so"
"libchromatix_imx477_cpp_video_hdr.so"
"libchromatix_imx477_hfr_120.so"
"libchromatix_imx477_hfr_60.so"
"libchromatix_imx477_hfr_90.so"
"libchromatix_imx477_preview.so"
"libchromatix_imx477_snapshot.so"
"libchromatix_imx477_snapshot_hdr.so"
"libchromatix_imx477_default_video.so"
"libchromatix_imx477_video_hdr.so"
"libchromatix_imx477_postproc.so"

#IMX179
#"libmmcamera_imx179.so"
#"libchromatix_imx179_4k_preview_bu64244gwz.so"
#"libchromatix_imx179_4k_video_bu64244gwz.so"
#"libchromatix_imx179_common.so"
#"libchromatix_imx179_cpp_hfr_120.so"
#"libchromatix_imx179_cpp_hfr_60.so"
#"libchromatix_imx179_cpp_hfr_90.so"
#"libchromatix_imx179_cpp_liveshot.so"
#"libchromatix_imx179_cpp_preview.so"
#"libchromatix_imx179_cpp_snapshot.so"
#"libchromatix_imx179_cpp_video_4k.so"
#"libchromatix_imx179_cpp_video.so"
#"libchromatix_imx179_default_preview_bu64244gwz.so"
#"libchromatix_imx179_default_video_bu64244gwz.so"
#"libchromatix_imx179_default_video.so"
#"libchromatix_imx179_hfr_120_bu64244gwz.so"
#"libchromatix_imx179_hfr_120.so"
#"libchromatix_imx179_hfr_60_bu64244gwz.so"
#"libchromatix_imx179_hfr_60.so"
#"libchromatix_imx179_hfr_90_bu64244gwz.so"
#"libchromatix_imx179_hfr_90.so"
#"libchromatix_imx179_postproc.so"
#"libchromatix_imx179_preview.so"
#"libchromatix_imx179_snapshot.so"
#"libchromatix_imx179_video_4k.so"
#"libchromatix_imx179_zsl_preview_bu64244gwz.so"
#"libchromatix_imx179_zsl_video_bu64244gwz.so"

#S5K5E2
#"libmmcamera_s5k5e2.so"
#"libchromatix_s5k5e2_common.so"
#"libchromatix_s5k5e2_postproc.so"
#"libchromatix_s5k5e2_snapshot.so"
#"libchromatix_s5k5e2_preview.so"
#"libchromatix_s5k5e2_default_video.so"
#"libchromatix_s5k5e2_cpp_preview.so"
#"libchromatix_s5k5e2_cpp_snapshot.so"
#"libchromatix_s5k5e2_cpp_video.so"
#"libchromatix_s5k5e2_cpp_liveshot.so"
#"libchromatix_s5k5e2_zsl_preview.so"
#"libchromatix_s5k5e2_zsl_video.so"
#"libchromatix_s5k5e2_a3_default_video.so"
#"libchromatix_s5k5e2_a3_default_preview.so"
)


HAL_LIBS=(
"camera.msm8953.so"
)

MM_CAMERA_XML_FILES=(
"obj/EXECUTABLES/msm8953_camera.xml_intermediates/msm8953_camera.xml"
"obj/EXECUTABLES/imx377_chromatix.xml_intermediates/imx377_chromatix.xml"
"obj/EXECUTABLES/imx377_chromatix.xml_intermediates/imx477_chromatix.xml"
"obj/EXECUTABLES/imx179_chromatix.xml_intermediates/imx179_chromatix.xml"
"obj/EXECUTABLES/s5k5e2_chromatix.xml_intermediates/s5k5e2_chromatix.xml"
)

MM_CAMERA_BIN_FILES=(
#"mm-qcamera-daemon"
)

if [ $NEEDS_DISABLE_VERIT == "true" ]; then
	./adb_Mac root
	sleep 1
	./adb_Mac disable-verity
	sleep 1
	./adb_Mac reboot
	read -n 1 -p "Press any key to continue process after device's reboot is done...."
fi


./adb_Mac root
sleep 1
./adb_Mac remount
sleep 1



#Download /systeb/vendor/lib
#counter=0
for DL_SYSTEM_VENDOR_LIBS in "${SYSTEM_VENDOR_LIBS[@]}"; do
	$SCP_CMD $ANDROID_IMG_DIR/system/vendor/lib/$DL_SYSTEM_VENDOR_LIBS $IMG_CACHE
	$ADB_CMD push $IMG_CACHE/$DL_SYSTEM_VENDOR_LIBS /system/vendor/lib
	#if [ "$counter" -eq "5" ]; then
	#	counter=0
	#	sleep 1
	#	echo "sleep 1 sec"
	#else
	#	counter=$((counter+1)) #counter=counter+1
	#	echo "counter=$counter"
	#fi
done

#Download HAL in hardware/qcom/camera
for DL_HAL_LIBS in "${HAL_LIBS[@]}"; do
	$SCP_CMD $ANDROID_IMG_DIR/symbols/system/lib/hw/$DL_HAL_LIBS $IMG_CACHE
	$ADB_CMD push $IMG_CACHE/$DL_HAL_LIBS /system/lib/hw
	#if [ "$counter" -eq "5" ]; then
	#	counter=0
	#	sleep 1
	#	echo "sleep 1 sec"
	#else
	#	counter=$((counter+1)) #counter=counter+1
	#	echo "counter=$counter"
	#fi
done

rm -rf $IMG_CACHE/*


#Download Camera xmls
#for DL_MM_CAMERA_XML_FILES in "${MM_CAMERA_XML_FILES[@]}"; do
#	$SCP_CMD $ANDROID_IMG_DIR/$DL_MM_CAMERA_XML_FILES $IMG_CACHE
#	#$ADB_CMD push $IMG_CACHE/$DL_MM_CAMERA_XML_FILES /etc/camera
#done
#rm -rf $IMG_CACHE/*

#Download /system/bin 
#for DL_MM_CAMERA_BIN_FILES in "${MM_CAMERA_BIN_FILES[@]}"; do
#	$SCP_CMD $ANDROID_IMG_DIR/system/bin/$DL_MM_CAMERA_BIN_FILES $IMG_CACHE
#done
#$ADB_CMD push $IMG_CACHE/ /system/bin


#IMG_CACHE_FILES=($(ls $IMG_CACHE/)) #list files output as array
#echo $IMG_CACHE_FILES
#for DL_MM_CAMERA_XML_FILES in "${MM_CAMERA_XML_FILES[@]}"; do
#for DL_MM_CAMERA_XML_FILES in "${IMG_CACHE_FILES[@]}"; do
#	$ADB_CMD push $IMG_CACHE/$DL_MM_CAMERA_XML_FILES /etc/camera
#done

#./adb_Mac push $IMG_CACHE/ /etc/camera

rm -rf $IMG_CACHE

echo "rebooting device"
./adb_Mac reboot
