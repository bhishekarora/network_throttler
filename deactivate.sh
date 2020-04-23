#!/bin/bash
#####################################################
#  Deactivate throttle 
#  
#  Author: Abhishek Arora
#  Licence: MIT
#####################################################

# usage ./deactivate.sh ifacename #####
#       ./deactivate.sh eth0   #####


echo "./deactivate.sh interface"

if [ $# -eq 0 ] ; then
echo "Specify interface name  e.g $./deactivate.sh eth0"
exit 
fi
echo "#Check the disc status#"

status=`tc qdisc show dev eth0`
echo "Status is " $status

if [ $? -eq 0 ] ; then
echo ""
tc qdisc del dev $1 root

[[ "$?" -ne 0 ]] && echo -e "\nCouldnt delete custom throttle rule , may be its in default mode already..." && exit


echo "Throttle deactivated"
fi

