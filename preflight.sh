#!/bin/bash

#####################################################
#  Preflight test to see if your systems supports
#  
#  Author: Abhishek Arora
#  Licence: MIT
#####################################################


echo "Checking interfaces"
count=`ifconfig|grep flags|wc -l`
ifaces=`ifconfig |grep flags`
echo "$count Interfaces found on system "
echo $ifaces
echo ""
echo "Most of the systems will throttle ethx  interface"


hash tc &>/dev/null && 
    echo "All programs installed, ** GOOD TO GO ** " ||
    echo "Tc command not found exiting,, try apt install iproute to fix"
    
    exit 


