#!/bin/bash
#####################################################
#  Deactivate throttle 
#  
#  Author: Abhishek Arora
#  Licence: MIT
#####################################################

if [ $# -eq 0 ] ; then
echo" Specify interface name  e.g $./deactivate.sh eth0"
exit 
fi
echo "#Check the disc status#"

status=`tc qdisc show dev eth0`
echo "Status is " $status

if [ $? -eq 1] ; then
echo ""
tc qdisc del dev $1 root
echo "Throttle deactivated"
fi

