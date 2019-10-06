#!/bin/bash

. ./bridge-conf 
#################################
# Set up tap0 interface
#################################


for t in $tap; do
    openvpn --mktun --dev $t
done

for t in $tap; do
    ifconfig $t $eth_ip netmask $eth_netmask
    iptables -A INPUT -i $t -j ACCEPT
done

sudo chmod -R 777 /var/lib/dhcp/dhcpd.leases

sudo dhcpd

sudo openvpn server.conf

