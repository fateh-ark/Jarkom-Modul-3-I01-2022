echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install squid -y
wait
echo "squid established"

cat /root/squid.conf > /etc/squid/squid.conf
wait
echo "squid configured"

service squid restart
wait
echo "squid service restarted"