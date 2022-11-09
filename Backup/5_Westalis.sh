echo nameserver 192.168.122.1 > /etc/resolv.conf

# Install Dependencies
apt-get update
apt-get install isc-dhcp-server -y