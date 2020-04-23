# Network throttler
Control the bandwidth on your Server/testing machine using this throttler, built with the linux traffic controller

If client requirement is to load a page @ 1mbps line and your testing team is testing on a 50 mbps and having trouble getting UAT signoffs, you need to throttle the testing server or the machine network to match what is there in the SLAs


## How to use ?

For linux users
===============
If testing team is using linux based system to run Jmeter/Load runner or other automated testing softwares for running the tests.

Please note that Jmeter and other softwares might contain the throttling settings that can be used to mimic the target environment

This will work out of the box and will cap the Bandwidth as per the options passed to the tool.

For windows users
================
If your testers are using windows based systems, in that case
this tool will be used as a gateway for that windows box.

Run this tool on any of the linux server in your environment which is accesible through your windows box and provide the 
details in the gateway section of the IPV4 settings on windows.

Make the dhcp to static and make it a C class network with gateway as the above box.

e.g

IPV4 settings
ip 192.168.1.2
netmask 255.255.255.0
gateway IP of the above linux box 


Sample runs
============

Without BW  test mode
====================

./activate.sh -i=eth0 -b=200kbit 
#######Throttler started #########

Checking the options passed.. target BW shouuld be in bits only kbit or mbit
e.g activate.sh -i=eth0 -b=1mbit 

###################################
Existing rule is default
####Bandwidth throttled to 200kbit


With BW Test mode 
===================

./activate.sh -i=eth0 -b=200kbit --bwtest
#######Throttler started #########

Checking the options passed.. target BW shouuld be in bits only kbit or mbit
e.g activate.sh -i=eth0 -b=1mbit 

###################################
#Checking existing bandwidth#
[  7]   0.00-10.00  sec  5.39 MBytes  4.52 Mbits/sec    9             sender
[  7]   0.00-11.66  sec  4.50 MBytes  3.24 Mbits/sec                  receiver

Existing rule is default
Checking new bandwidth after rules applied
[  7]   0.00-10.01  sec   351 KBytes   287 Kbits/sec    0             sender
[  7]   0.00-10.61  sec   239 KBytes   184 Kbits/sec                  receiver
####Bandwidth throttled to 200kbit

