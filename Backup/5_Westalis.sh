echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install isc-dhcp-server -y
wait
echo "isc-dhcp-server established"

# DHCPD configurations
cat /root/iscdhcp.conf > /etc/default/isc-dhcp-server
wait
echo "isc-dhcp-server configuration established"

cat /root/dhcp.conf > /etc/dhcp/dhcpd.conf
wait
echo "dhcpd.conf configuration established"

# Restart Service
service isc-dhcp-server restart
wait
echo "dhcpd service restarted"