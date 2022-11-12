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

## Question 5

> Client gets the DNS from WISE and client can connect to the internet through the DNS.

Other than putting `option domain-name-servers 10.36.2.2;` to each subnets, the DNS server must forward to the DNS server given by **NAT 1** which is `nameserver 192.168.122.1` which provide to the wider internet.

Put the following lines to /etc/bind/**named.conf.options** on WISE:

```conf
options {
    directory "/var/cache/bind";

    forwarders{
        192.168.122.1;
    };

    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```

**Result:**

![Pinging Google.com from Eden](https://i.imgur.com/HOVXhcD.png)

## Question 6

> The length of time the DHCP server lends an IP address to client via Switch1 is 5 minutes, while the client via Switch3 is 10 minutes. With a maximum time allocated for borrowing an IP address is 115 minutes. 

Put the following line to parts of /etc/dhcp/**dhcpd.conf** on Westalis:

+ 5 Minutes for Subnet **10.36.1.0**. 5 x 60 = 300, Append the following to the subnet config<br>`default-lease-time 300;`.
+ 10 Minutes for Subnet **10.36.3.0**. 10 x 60 = 600, Append the following to the subnet config<br>`default-lease-time 600;`.
+ 115 Minutes maximum lease time for **both subnets**. 115 x 60 = 6900, Appen the follwowing to each subnet configs<br>`max-lease-time 6900;`.

## Question 7

> Loid and Franky plan to make Eden as a server for exchanging information with a fixed IP address with IP [prefix IP].3.13 (7).

Append the following to /etc/dhcp/**dhcpd.conf** on Westalis:

```conf
host Eden {
    hardware ethernet 4e:9f:50:f8:46:b6;
    fixed-address 10.36.3.13;
}
```

since the interface MAC address changes everytime the GNS3 project is closed, manual change are required for each boot.

**Result:**

![Eden Static IP address](https://i.imgur.com/s8lbPdd.png)

## Question 8

> On the Proxy Server Berlint, Loid plans to manage how client can access the internet. This means that every client must use SSS as HTTP & HTTPS proxy.

Append the following to Berlint script.sh:

```sh
cat /root/squid.conf > /etc/squid/squid.conf
wait
echo "squid configured"

service squid restart
wait
echo "squid service restarted"
```

Create /etc/squid/**squid.conf** with the following:

```conf
acl eden src 10.36.3.13
acl switch1 src 10.36.1.0/24

visible_hostname Berlint

http_access allow eden
http_access allow switch1
```

Used for identifying the 3 clients (Eden,SSS,Garden) to use the proxy server.

Additional configs are as follows:

### Requirement 1

> Client can only access the internet outside (other than) working days & hours (Monday-Friday 08.00-17.00) and holidays (could access 24 hours a day)

Append the following to /etc/squid/**squid.conf** in Berlint:

```conf
acl workinghour time M T W H F 08:00-17:00

http_access deny all workinghour
http_access allow all
```

+ `acl workinghour time M T W H F 08:00-17:00` defines the working hour of **Monday-Friday 08.00-17.00**.
+ the last 2 lines tells that it will deny all connection within the specified time, else (on holiday or outside of working hour) it will allow all connection.

### Requirement 2

> As for the working days and hours according to number (1), client could only access loid-work.com and franky-work.com domain

Append the following to /etc/squid/**squid.conf** in Berlint:

```conf
acl loidfranky src 10.36.3.0/24

http_access allow loidfranky workinghour
http_access deny loidfranky
```

Loidyfrank is assigned as the rest of the clients in the switch 3 subnet. The DNS server haven't been configured for it.

### Requirement 3

> When the internet access is opened, client is prohibited from accessing web without HTTPS. (HTTP web example: http://example.com)

Append the following to /etc/squid/**squid.conf** in Berlint:

```conf
acl httpsport port 443 8443

http_access deny !httpsport
```

Denies all ports except from those HTTPS assigned port such as **443 & 8433**. 

### Requirement 4

> In order to save usage, internet access is limited to a maximum speed of 128 Kbps on each host (Kbps = kilobits per second; check on each host, when 2 hosts access the internet at the same time, both get a maximum speed of 128 Kbps)

Not Done.

### Requirement 5

> After being implemented, it turns out that rule number (4) decreases the productivity during weekdays, thus speed restrictions are only applied to the internet access on holidays

Not Done

# Revisions & Dificulties

+ Proxy has not been fully configured as per according to the questions
+ We are not sure if the proxy server are working or not.
+ MAC address changes everytime the GNS3 project is closed, manual change are required for question 7 on each boot.