#!/bin/bash
#$1 node number
NETWORKS=("192.168.0.0" "192.168.100.0" "192.168.200.0")
BASE_IP=100
IP=`expr $BASE_IP + $1`
cnt=0
for NETWORK in ${NETWORKS[@]}; do
        #get network prefix
        SEGMENT=`echo ${NETWORK} | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.'`
        eval `ipcalc -s -p ${NETWORK}/24`
        vxlanip="${SEGMENT}${IP}"
        cat > /etc/vxlan/vxlan${cnt}.conf <<EOF
vInterface = vxlan${cnt}
Id = 1${cnt}
Ether = eth0
List = /etc/vxlan/all.ip
Address = ${vxlanip}/${PREFIX}
EOF

        cnt=`expr $cnt + 1`
done
