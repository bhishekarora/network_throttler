# Network throttler

Control the bandwidth on your Server/Testing machine using this throttler, built with the linux traffic controller

![Architecture](https://github.com/bhishekarora/network_throttler/blob/master/networkthrottler.png)

  

If client requirement is to load a page @ 1mbps line and your testing team is testing on a 50 mbps and having trouble getting UAT signoffs, you need to throttle the testing server or the machine network to match what is there in the SLAs
 
  
 ##  How to use ?

    $ git clone  https://github.com/bhishekarora/network_throttler.git
    $cd network_throttler
    $ chmod +x *
    $ ifconfig //  find the ifaces you have , most probably it will be ethx . e.g eth0
    
    $ ./activate.sh -i=eth0 -b=200kbit                    // without BW Test
    $./activate.sh -i=eth0 -b=200kbit --bwtest       // needs iperf server *
    $./deactivate.sh eth0                                       // To reset the throttler 

* *iperf is shipped with this repo, if you want to use BW test also do the following else skip.*

> * Run $iperf3 -s on another box on the network reachable from this tool and put that ip address in the first line of the activate.sh
> script so that real time bw test can be tested, by default public
> server ip is configured and some times public servers are busy running
> other bandwidth tests...

## Compatibility

  

**For linux users**

===============

If testing team is using linux based system to run Jmeter/Load runner or other automated testing softwares for running the tests.

  

> Please note that Jmeter and other softwares might contain the
> throttling settings that can be used to mimic the target environment

  

This will work out of the box and will cap the Bandwidth as per the options passed to the tool.

  

**For windows users**

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

> Also if there is a substantial packet delay from windows box to the
> gateway where you are configuring this tool , that delay need to be
> considered if using this tool in delay mode.

 

## Sample runs

**Bandwidth throttle mode** 

/activate.sh -i=eth0 -b=200kbit --bwtest  

![BW Throttle with bwtest](https://github.com/bhishekarora/network_throttler/blob/master/throttlewithbwtest.png)

> UseCase
> 
> Client has remote sites which have limited bandwidth in kbs and want
> to use your system.


**Packet delay mode**


/activate.sh -i=eth0 -d=200ms 

![Packet delay mode ](https://github.com/bhishekarora/network_throttler/blob/master/packetdelay.png)

> UseCase Client has an SLA that the packet delay from your server to
> the end users on remote sites should not be this much milliseconds

** If you are not hosting your own iperf3 server and test with --bwtest option you will 
have to use the public server US based and it might be busy running other tests, so you might have to run the script  multiple times**