#!/bin/sh
#
# More stuff: man netsniff-ng
#
#  Start sniffing in verbose mode on device eth0 
#  for ICMP messages:
#

netsniff-ng -d eth0 -f /etc/netsniff-ng/rules/icmp.bpf -C
