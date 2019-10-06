#!/bin/bash

. ./bridge-conf
####################################
# Tear Down tap0 interface on Linux
####################################


for t in $tap; do
    openvpn --rmtun --dev $t
    iptables -D INPUT -i $t -j ACCEPT
done

