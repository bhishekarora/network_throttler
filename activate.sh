#!/bin/bash
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


delay=0ms
iperfserver=iperf.he.net

for i in "$@"
do
case $i in
    -i=*|--interface=*)
    interface="${i#*=}"
    shift # past argument=value
    ;;
    -b=*|--bandwidth=*)
    bw="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--delay=*)
    delay="${i#*=}"
    shift # past argument=value
    ;;
    --bwtest)
    bwtest=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
          echo "script usage: For BW Throttle $(basename $0) [-i=eth0 ] [-b=200kbit] " >&2
          echo ""
      echo "script usage: For Delay  $(basename $0) [-i=eth0 ] [-d=200ms] " >&2
      echo ""

      echo "Add --bwtest if you want to run a bandwidht test also while throttling"
      echo ""
      echo " ./activate.sh -i=eth0 -b=200kbit --bwtest"
     
        echo ""
        echo "** --bwtest valid only for the bandwidth throttle mode , it runs a default for delay mode**"
      exit
    
    ;;
esac
done



echo "#######Throttler started #########"
echo ""
echo "Checking the options passed.. target BW shouuld be in bits only kbit or mbit"
echo "e.g activate.sh -i=eth0 -b=1mbit "
echo ""
echo "###################################"





#echo "values " $bw $delay $interface


    if [ $delay != "0ms" ] ; then
    echo "Before delay "
    echo "============="
    echo "Checking packet delay before setting"
    echo""
    ping -q -c 5 google.com |grep avg
    tc qdisc add dev $interface root netem delay $delay
    
  
    if [ "$?" -ne 0 ] ; then
    
    echo "Couldnt set delay  , try deactivation script first "
    echo ""

    echo "Will exit now .. "
    exit
    else
    echo ""
    fi

    echo "Delay set .......Sucess"
    echo""
    echo " Device status after delay set "
    echo""
    tc qdisc show  dev $interface   
    echo ""
    echo "######Checking the packet latency now......###"
    ping -q -c 5 google.com |grep avg

    echo ""
    echo "To reset the delay , run $./deactivate.sh " 
    exit
    fi


#find the queue discipline rules for this interface
rulecount=`tc qdisc show  dev $interface |grep fifo|wc -l`

#tbf: use the token buffer filter to manipulate traffic rates
#rate: sustained maximum rate
#burst: maximum allowed burst
#latency: packets with higher latency get dropped

if [ "$bwtest" = "YES" ] ; then
echo "#Checking existing bandwidth#"
iperf3 -c $iperfserver |grep 'sender\|receiver' 
echo ""
fi

if [ $rulecount -eq 1  ] ;then
echo "Existing rule is default"
#modify queue disciple according to the bandwidth/burst <tcp window size /latency specified
tc qdisc add dev $interface root tbf rate $bw burst 32kbit latency 400ms
#buket burst is 32k will allow small files to download easily and will throttle .. as per bw 
[[ "$?" -ne 0 ]] && echo -e "\nError occured exiting...coundnt shape traffic..." && exit

if [ "$bwtest" = "YES" ] ; then
echo "Checking new bandwidth after rules applied"
iperf3 -c $iperfserver |grep 'sender\|receiver' 
fi

echo "####Bandwidth throttled to $bw"

else
echo "Multiple rules found...not equipped to handle it yet..exiting.."
echo "======================================"
echo "Let me know if you want to reset y/n ?"
read reset 

if [ "$reset" = "y" ] ; then
echo "Reseting the default rule.."
tc qdisc del dev eth0 root

[[ "$?" -ne 0 ]] && echo -e "\nError deleting rule .." && exit

echo "Please restart the activate.sh script.. rule is deleted.."

else
echo "You pressed  n or didnt enter right value Exiting...now bbye.."
fi

fi




