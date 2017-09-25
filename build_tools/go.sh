#suggest to put the file into /bin/ so it'll still exist after reboot
mount -o rw,remount /
sleep 2
sed -i "s/null::respawn:\/bin\/ubnt_ispserver/#null::respawn:\/bin\/ubnt_ispserver/" /etc/inittab
sed -i "s/null::respawn:\/bin\/ubnt_streamer/#null::respawn:\/bin\/ubnt_streamer/" /etc/inittab
kill -1 1
sleep 2
pkill ispserver
pkill streamer
sleep 1
mv /tmp/ubnt_ispserver /bin/
reboot