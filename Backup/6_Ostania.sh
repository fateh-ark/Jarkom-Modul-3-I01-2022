iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.36.0.0/16
wait
echo "iptables established"

# Install Dependencies
apt-get update
apt-get install isc-dhcp-relay -y
wait
echo "isc-dhcp-relay established"

# Configure DHCRELAY
cat /root/dhcprelay.conf > /etc/default/isc-dhcp-relay
wait
echo "dhcrelay configuration established"

# Restart Service
service isc-dhcp-relay restart
wait
echo "isc-dhcp relay service restarted"