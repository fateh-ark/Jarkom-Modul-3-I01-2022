# Jarkom-Modul-3-I01-2022

**Computational Networking Module 3 Practicum Report**

Group Members:

+ Adam Satria Adidarma - 05111942000001
+ Muhammad Fatih Akbar - 5025201117
+ Rangga Aulia Pradana - 5025201154

## Important Links

+ [Questions](https://docs.google.com/document/d/16-TB_sWtMhpJ931ZcszS8vojsVN6O_-anbA5NpA3iI4/edit?usp=sharing)

## Table Of Contents

- [Jarkom-Modul-3-I02-2022](#jarkom-modul-3-i02-2022)
  - [Important Links](#important-links)
  - [Table Of Contents](#table-of-contents)
- [Answers](#answers)
  - [Question 1 & 2](#question-1--2)
  - [Question 3](#question-3)
  - [Question 4](#question-4)
  - [Question 5](#question-5)
  - [Question 6](#question-6)
  - [Question 7](#question-7)
  - [Question 8](#question-8)
    - [Requirement 1](#requirement-1)
    - [Requirement 2](#requirement-2)
    - [Requirement 3](#requirement-3)
    - [Requirement 4](#requirement-4)
    - [Requirement 5](#requirement-5)
- [Revisions & Dificulties](#revisions--dificulties)

# Answers

## Question 1 & 2

> Loid with Franky plan to create the map above with criteria WISE as DNS Server, Westalis as DHCP Server, Berlint as Proxy Server (1), and Ostania as DHCP Relay (2). Loid and Franky **construct the map carefully and thoroughly.**

![Structure](https://i.imgur.com/yZdZN2Q.png)

Network Configuration:

```conf
# Ostania - DHCP Relay
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.36.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.36.2.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.36.3.1
	netmask 255.255.255.0

# WISE - DNS Server
auto eth0
iface eth0 inet static
	address 10.36.2.2
	netmask 255.255.255.0
	gateway 10.36.2.1

# Berlint - Proxy Server
auto eth0
iface eth0 inet static
	address 10.36.2.3
	netmask 255.255.255.0
	gateway 10.36.2.1

# Westalis - DHCP Server
auto eth0
iface eth0 inet static
	address 10.36.2.4
	netmask 255.255.255.0
	gateway 10.36.2.1

# Other Clients
auto eth0
iface eth0 inet dhcp
```

**All Client** .bashrc, appended are:

```sh
# Append The Following to each nodes .bashrc
chmod +x /root/script.sh
/root/script.sh
```

**WISE** as a DNS Server, script.sh:

```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install bind9 -y
wait
echo "bind9 established"
```

**Berlint** as Proxy Server, script.sh:

```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install squid -y
wait
echo "squid established"
```

**Westalis** as DHCP Server, script.sh:

```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"

# Install Dependencies
apt-get update
apt-get install isc-dhcp-server -y
wait
echo "isc-dhcp-server established"
```

**Ostania** as DHCP Relay & Router, script.sh:

```sh
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
```

**Ostania** DHCP Relay Configuration:

```conf
# DHCP Server Address
SERVERS="10.36.2.4"

# Serve Most Interfaces
INTERFACES="eth1 eth3 eth2"

# Optional Options
OPTIONS=""
```

Other Clients:

```sh
echo nameserver 192.168.122.1 > /etc/resolv.conf
wait
echo "/etc/resolv.conf established"
wait

# Runs the DHCP discovery again until a lease is discovered.
/tmp/gns3/bin/udhcpc
```

## Question 3

> Client that go through Switch1 have the IP range from [prefix IP].1.50 - [prefix IP].1.88 and [prefix IP].1.120 - [prefix IP].1.155

Append to **Westalis's** script.sh:

```sh

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
```

/etc/default/**isc-dhcp-server** on Westalis:

```conf
# Interface Output
INTERFACES="eth0"
```

/etc/dhcp/**dhcpd.conf** on Westalis:

```conf
subnet 10.36.1.0 netmask 255.255.255.0 {
    range  10.36.1.50 10.36.1.88;
    range  10.36.1.120 10.36.1.155;
    option routers 10.36.1.1;
    option broadcast-address 10.36.1.255;
    option domain-name-servers 10.36.2.2;
}
```

+ `range  10.36.1.50 10.36.1.88;` for the first range.
+ `range  10.36.1.120 10.36.1.155;` for the second range.
+ `option routers 10.36.1.1;` router interface that connects to swtich 1.
+ `option domain-name-servers 10.36.2.2;` DNS server, IP address of WISE.

**Result:**

![SSS IP address](https://i.imgur.com/wAh86Zp.png)

![Garden IP address](https://i.imgur.com/47rtVHI.png)

## Question 4

> Client that go through Switch3 have the IP range from [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85

append to /etc/dhcp/**dhcpd.conf** on Westalis:

```conf
subnet 10.36.3.0 netmask 255.255.255.0 {
    range  10.36.3.10 10.36.3.30;
    range  10.36.3.60 10.36.3.85;
    option routers 10.36.3.1;
    option broadcast-address 10.36.3.255;
    option domain-name-servers 10.36.2.2;
}
```

+ `range  10.36.3.10 10.36.3.30;` for the first range.
+ `range  10.36.3.60 10.36.3.85;` for the second range.
+ `option routers 10.36.3.1;` router interface that connects to swtich 3.
+ `option domain-name-servers 10.36.2.2;` DNS server, IP address of WISE.

**Result:**

![KemonoPark IP address](https://i.imgur.com/o1NFIF4.png)

![NewstonCastle](https://i.imgur.com/bj1VYuU.png)
