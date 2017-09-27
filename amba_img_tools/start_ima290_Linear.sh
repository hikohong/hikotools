# IMX290 HDR
export PATH=/usr/local/bin:$PATH

amba_debug -g 22 -d 0
amba_debug -g 22 -d 1

echo "setting network"
ifconfig eth0 192.168.1.100
sleep 1
ifup eth0
sleep 2
telnetd
sleep 2

echo "sensor driver up"
init.sh --imx290
sleep 2

echo "run tuning server"
test_tuning -a &
sleep 2

# set encoding for sensor: HDR mode
echo "running encode server"
#Linear basic mode (mode 4) aliso
test_encode -i 1080p -f 30 -V480p --hdmi --hdr-mode 0 --hdr-expo 1 --enc-mode 4
#HDR basic HDR mode (mode 4) aliso
#test_encode -i 1080p -f 30 -V480p --hdmi --hdr-mode 1 --hdr-expo 2 --enc-mode 4
#Advanced HDR (mode 5) miso
#test_encode -i 1080p -f 30 -V480p --hdmi --hdr-mode 2 --hdr-expo 3 --enc-mode 5 --mixer 0

sleep 1
echo "running rtsp server"
rtsp_server &

sleep 1
echo "preview 1080p"
test_encode -A -h 1080p -e

stty -F /dev/ttyS1 115200 raw
sleep
echo -en "\x81\x01\x04\x19\x01\xFF" > /dev/ttyS1
sleep 4
echo -en "\x81\x01\x04\x47\x00\x00\x02\x00\xFF" > /dev/ttyS1
sleep 1
echo -en "\x81\x01\x04\x47\x00\x00\x02\x0F\xFF" > /dev/ttyS1

