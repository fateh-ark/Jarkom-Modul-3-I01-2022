iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.36.0.0/16

# Install Dependencies
apt-get update
apt-get install isc-dhcp-relay -y