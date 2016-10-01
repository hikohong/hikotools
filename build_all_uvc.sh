#!/bin/bash

function show_usage()
{
    echo "==================================================================================="
    echo " Flash downloading processes"
    echo " Author hikohong"
    echo "   ./build_all_uvc.sh CODEBASE_ROOT BUILD_OPTION DEPLOY_OPTION"
    echo "   ./build_all_uvc.sh -h (call help)"
    echo "   Example:"
    echo "   ./build_all_uvc.sh"
    echo "   ./build_all_uvc.sh -b"
    echo "   ./build_all_uvc.sh -b --dep ./"
    echo "-----------------------------------------------------------------------------------"
    echo "[BUILD_OPTION] the building option"
    echo " -b --build (default) exec building process"
    echo " --nb exec no building process"
    echo "[DEPLOY_OPTION] optional setting"
    echo "  --nodep(default) --dep"
    echo "[CODEBASE_ROOT] The codebase root"
    echo "  ./(default) (current location)"
    echo "==================================================================================="
}


CODEBASE_ROOT="."
GEN2_BIN_PATH=$CODEBASE_ROOT/openwrt-gen2-dbg/artifacts
GEN3L_BIN_PATH=$CODEBASE_ROOT/openwrt-gen3l-dbg/artifacts
GEN3M_BIN_PATH=$CODEBASE_ROOT/openwrt-gen3m-dbg/artifacts
BUILD_PROCESS=true
DEPLOY_PROCESS=false


GEN2_IPADDRS=(
"10.2.0.222"
"10.2.0.141"
)

GEN3L_IPADDRS=(
"10.2.0.121"
"10.2.0.91"
)

GEN3M_IPADDRS=(
"10.2.1.92"
)

##############
#main process
##############

if [ -n "$1" ]; then
    case $1 in
    -h|*)
    show_usage
    exit 1
    ;;
    --nb)
    build_process=false
    ;;
    esac
fi

if [ -n "$2" ]; then
    case $2 in
    --dep)
    DEPLOY_PROCESS=true
    ;;
    --nodep)
    DEPLOY_PROCESS=false
    ;;
    *)
    show_usage
    exit 1
    ;;
    esac
fi

#building gen2 gen3l and gen3m
if [ "$BUILD_PROCESS" == "ture" ]; then
    make gen2-dbg/fw
    make gen3l-dbg/fw
    make gen3m-dbg/fw
fi

if [ "$DEPLOY_PROCESS" == "true" ]; then
    for GEN2_DEV_IP in "${GEN2_IPADDRS[@]}"; do
        echo "scp into GEN2 $GEN2_DEV_IP"
        find $GEN2_BIN_PATH/ -name *.bin -exec sshpass -p ubnt scp {} ubnt@$GEN2_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN2_DEV_IP 'fwupdate -m'
    done

    for GEN3L_DEV_IP in "${GEN3L_IPADDRS[@]}"; do
        echo "scp into GEN3L $GEN3L_DEV_IP"
        find $GEN3L_BIN_PATH/ -name *.bin -exec sshpass -p ubnt scp {} ubnt@$GEN3L_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN3L_DEV_IP 'fwupdate -m'
    done

    for GEN3M_DEV_IP in "${GEN3M_IPADDRS[@]}"; do
        echo "scp into GEN3M $GEN3M_DEV_IP"
        find $GEN3M_BIN_PATH/ -name *.bin -exec sshpass -p ubnt scp {} ubnt@$GEN3M_DEV_IP:/tmp/fwupdate.bin \;
        sshpass -p ubnt ssh ubnt@$GEN3M_DEV_IP 'fwupdate -m'
    done
fi

