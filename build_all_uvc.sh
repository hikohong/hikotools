#!/bin/bash

function show_usage()
{
    echo "==================================================================================="
    echo " Flash downloading processes"
    echo " Author hikohong"
    echo "   ./build_all_uvc.sh BUILD_OPTION DEPLOY_OPTION CODEBASE_ROOT"
    echo "   ./build_all_uvc.sh -h (call help)"
    echo "   Example:"
    echo "   ./build_all_uvc.sh"
    echo "   ./build_all_uvc.sh -b"
    echo "   ./build_all_uvc.sh -b --dep ./"
    echo "-----------------------------------------------------------------------------------"
    echo "[BUILD_OPTION] the building option"
    echo " -b --build build fw bin files"
    echo " --bm --buid_mid build middleware libs"
    echo " --ba --build_all build both middleware and fw bin"
    echo " --nb exec no building process"
    echo "[DEPLOY_OPTION] optional setting"
    echo "  --nd --nodep(default) --dep -d"
    echo "[CODEBASE_ROOT] The codebase root"
    echo "  ./(default) (current location)"
    echo "==================================================================================="
}

function make_middleware()
{
    cd $GEN2_MID_PATH
    make package/ubnt-middleware/compile V=99
    cd $GEN3L_MID_PATH
    make package/ubnt-middleware/compile V=99
    cd $GEN3M_MID_PATH
    make package/ubnt-middleware/compile V=99
    cd $CODEBASE_ROOT
}


CODEBASE_ROOT=`pwd`
GEN2_MID_PATH=$CODEBASE_ROOT/openwrt-gen2-dbg
GEN3L_MID_PATH=$CODEBASE_ROOT/openwrt-gen3l-dbg
GEN3M_MID_PATH=$CODEBASE_ROOT/openwrt-gen3m-dbg
GEN2_BIN_PATH=$GEN2_MID_PATH/artifacts
GEN3L_BIN_PATH=$GEN3L_MID_PATH/artifacts
GEN3M_BIN_PATH=$GEN3M_MID_PATH/artifacts
BUILD_PROCESS=fw
DEPLOY_PROCESS=false


GEN2_IPADDRS=(
"10.2.129.93"
"10.2.129.70"
"10.2.129.115"
)

GEN3L_IPADDRS=(
"10.2.129.88"
"10.2.129.92"
"10.2.129.49"
"10.2.128.135"
)

GEN3M_IPADDRS=(
"10.2.129.16"
"10.2.128.104"
)

##############
#main process
##############

if [ -n "$1" ]; then
    case $1 in
        --nb)
        BUILD_PROCESS=false
        ;;
        -b|--build)
        BUILD_PROCESS=fw
        ;;
        --bm|build_mid)
        BUILD_PROCESS=middleware
        ;;
        --ba|--buid_all)
        BUILD_PROCESS=fw_middleware
        ;;
        #this should be in latest case of the switch
        -h|*)
        show_usage
        exit 1
        ;;
    esac
else
    show_usage
    exit 1
fi

if [ -n "$2" ]; then
    case $2 in
        -d|--dep)
        DEPLOY_PROCESS=true
        ;;
        --nd|--nodep)
        DEPLOY_PROCESS=false
        ;;
        *)
        show_usage
        exit 1
        ;;
    esac
fi

if [ -n "$3" ]; then
    CODEBASE_ROOT=$3
    GEN2_MID_PATH=$CODEBASE_ROOT/openwrt-gen2-dbg
    GEN3L_MID_PATH=$CODEBASE_ROOT/openwrt-gen3l-dbg
    GEN3M_MID_PATH=$CODEBASE_ROOT/openwrt-gen3m-dbg
    GEN2_BIN_PATH=$GEN2_MID_PATH/artifacts
    GEN3L_BIN_PATH=$GEN3L_MID_PATH/artifacts
    GEN3M_BIN_PATH=$GEN3M_MID_PATH/artifacts
fi

#building gen2 gen3l and gen3m
case $BUILD_PROCESS in
    fw)
        make gen2-dbg/fw
        make gen3l-dbg/fw
        make gen3m-dbg/fw
    ;;
    middleware)
        make_middleware
    ;;
    fw_middleware)
        make_middleware
        make gen2-dbg/fw
        make gen3l-dbg/fw
        make gen3m-dbg/fw
    ;;
esac

if [ "$DEPLOY_PROCESS" == "true" ]; then
    for GEN2_DEV_IP in "${GEN2_IPADDRS[@]}"; do
        echo "scp into GEN2 $GEN2_DEV_IP"
        find $GEN2_BIN_PATH/ -name UVC*.bin -exec sshpass -p ubnt scp {} ubnt@$GEN2_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN2_DEV_IP 'fwupdate -m'
    done

    for GEN3L_DEV_IP in "${GEN3L_IPADDRS[@]}"; do
        echo "scp into GEN3L $GEN3L_DEV_IP"
        find $GEN3L_BIN_PATH/ -name UVC*.bin -exec sshpass -p ubnt scp {} ubnt@$GEN3L_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN3L_DEV_IP 'fwupdate -m'
    done

    for GEN3M_DEV_IP in "${GEN3M_IPADDRS[@]}"; do
        echo "scp into GEN3M $GEN3M_DEV_IP"
        find $GEN3M_BIN_PATH/ -name UVC*.bin -exec sshpass -p ubnt scp {} ubnt@$GEN3M_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN3M_DEV_IP 'fwupdate -m'
    done
fi

