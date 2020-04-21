#!/bin/sh
#####################################################
#  Throttle system bandwidth V1
#  
#  Author: Abhishek Arora
#  Licence: MIT
#####################################################


#qdisc: modify the scheduler (aka queuing discipline)
#add: add a new rule
#dev eth0: rules will be applied on device eth0
#root: modify the outbound traffic scheduler (aka known as the egress qdisc)
#netem: use the network emulator to emulate a WAN property
#delay: the network property that is modified
#200ms: introduce delay of 200 ms

echo "#######Throttler started #########"
echo ""
echo "Checking the options passed.. target BW shouuld be in bits only"
latency=0ms
    while getopts ":hibl" opt; do
                case ${opt} in
                        h ) 
                        echo "Usage:"
                        echo "activate.sh -i eth0 -b 200kbit                 -i interface -b targetbandwidth"
                        echo "activate.sh -i eth0 -b 1mbit -l  50ms         -i interface -b targetbandwidth -l induced latency"
                        exit
                        ;;
                        i ) 
                        interface="$OPTARG"
                        ;;
                        b ) 
                        bw="$OPTARG"
                        ;;
                        l ) 
                        latency="$OPTARG"
                        ;;
                        \? ) echo "Usage: activate.sh -i eth0 -b 1mbits"
                        ;;
                esac
                done



#find the queue discipline rules for this interface
qdiscinfo=`tc qdisc show  dev $interface |grep fifo`
rulecount=$qdiscinfo|wc -l

#tbf: use the token buffer filter to manipulate traffic rates
#rate: sustained maximum rate
#burst: maximum allowed burst
#latency: packets with higher latency get dropped

echo "#Checking existing bandwidth#"
iperf3 -c 192.168.1.5 |grep 'sender\|receiver' 

if [ $rulecount -eq 1  ] ;then
echo "Existing rule is default"
#modify queue disciple according to the bandwidth/burst <tcp window size /latency specified
tc qdisc add dev $interface root tbf rate $bandwidth burst 32kbit latency $latency

[[ "$?" -ne 0 ]] && echo -e "\nError occured exiting...coundnt shape traffic..." && exit

echo "Checking new bandwidth after rules applied"
iperf3 -c 192.168.1.5 |grep 'sender\|receiver' 

echo "####Bandwidth throttled to $bandwidth+delta"

else
echo "Multiple rules found"

fi




