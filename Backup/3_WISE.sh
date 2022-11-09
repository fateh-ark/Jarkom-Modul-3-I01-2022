echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install bind9 -y
wait
echo "bind9 established"

cat /root/forwarder.conf > /etc/bind/named.conf.options
wait
echo "forwarder configured"

service bind9 restart
wait
echo "bind9 service restarted"