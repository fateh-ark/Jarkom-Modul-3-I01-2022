echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"
wait
/tmp/gns3/bin/udhcpc