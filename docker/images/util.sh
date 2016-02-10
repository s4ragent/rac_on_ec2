NODEPREFIX="node"
DOMAIN_NAME="public"
SCAN_NAME="scan"
BASE_IP=50
NETWORKS=("192.168.0.0" "192.168.100.0" "192.168.200.0" "192.168.250.0")
HOSTFILE=/tmp/hosts


getnodename ()
{
	echo "$NODEPREFIX"`printf "%.3d" $1`;
}

getip () {
	SEGMENT=`echo ${NETWORKS[$1]} | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.'`; 
	if [ $2 == "real" ] ; then 
		IP=`expr $BASE_IP + $3`; 
		echo "${SEGMENT}${IP}";
	elif [ $2 == "vip" ] ; then 
		IP=`expr $BASE_IP + 100 + $3`; 
		echo "${SEGMENT}${IP}";
	elif [ $2 == "host" ] ; then 
		IP=`expr $BASE_IP - 10 + $3`;
		echo "${SEGMENT}${IP}";
	elif [ $2 == "scan" ] ; then
		echo "${SEGMENT}`expr $BASE_IP - 20 ` ${SCAN_NAME}.${DOMAIN_NAME} ${SCAN_NAME}";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 1` ${SCAN_NAME}.${DOMAIN_NAME} ${SCAN_NAME}";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 2` ${SCAN_NAME}.${DOMAIN_NAME} ${SCAN_NAME}";
	elif [ $2 == "nas" ] ; then
		echo "${SEGMENT}`expr $BASE_IP - 20 + 3` nas1.${DOMAIN_NAME} nas1";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 4` nas1.${DOMAIN_NAME} nas2";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 5` nas1.${DOMAIN_NAME} nas3";
	elif [ $2 == "other" ] ; then
		echo "${SEGMENT}`expr $BASE_IP - 20 + 6` db1.${DOMAIN_NAME} db1";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 7` db2.${DOMAIN_NAME} db2";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 8` oem1.${DOMAIN_NAME} oem1";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 9` oem2.${DOMAIN_NAME} oem2";						
		echo "${SEGMENT}`expr $BASE_IP - 20 + 10` client1.${DOMAIN_NAME} client1";
		echo "${SEGMENT}`expr $BASE_IP - 20 + 11` client2.${DOMAIN_NAME} client2";		
	fi;
}

createhosts()
{
	cat > $HOSTFILE <<EOF
127.0.0.1 localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

	getip 0 scan >> $HOSTFILE
	getip 3 nas >> $HOSTFILE
	getip 0 other >> $HOSTFILE
	for i in `seq 1 64`; do 
		nodename=`getnodename $i`;
		echo "`getip 0 real $i` $nodename".${DOMAIN_NAME}" $nodename" >> $HOSTFILE;
		vipnodename=$nodename"-vip";
		vipi=`expr $i + 100`;
		echo "`getip 0 real $vipi` $vipnodename".${DOMAIN_NAME}" $vipnodename" >> $HOSTFILE;
	done
}

createsshkey()
{
WORK_DIR=/work
mkdir -p $WORK_DIR

ssh-keygen -t rsa -P "" -f /work/id_rsa
hostkey=`cat /etc/ssh/ssh_host_rsa_key.pub`
for i in `seq 1 64`; do
    nodename=`getnodename $i`
    ip=`expr $BASE_IP + $i`
    echo "${nodename},`getip 0 real $i` $hostkey" >> /work/known_hosts
done

for user in oracle grid oracleja gridja
do
	mkdir /home/$user/.ssh
	cat /work/id_rsa.pub >> /home/$user/.ssh/authorized_keys
	cp /work/id_rsa /home/$user/.ssh/
	cp /work/known_hosts /home/$user/.ssh
	chown -R ${user}.oinstall /home/$user/.ssh
	chmod 700 /home/$user/.ssh
	chmod 600 /home/$user/.ssh/*
done
	rm -rf $WORK_DIR/id_rsa $WORK_DIR/id_rsa.pub $WORK_DIR/known_hosts
}

createvxlanconf()
{
cnt=0
for NETWORK in ${NETWORKS[@]}; do
        #get network prefix
        SEGMENT=`echo ${NETWORK} | grep -Po '\d{1,3}\.\d{1,3}\.\d{1,3}\.'`
        eval `ipcalc -s -p ${NETWORK}/24`
        vxlanip=`getip $cnt real $1`
        cat > /etc/vxlan/vxlan${cnt}.conf <<EOF
vInterface = vxlan${cnt}
Id = 1${cnt}
Ether = eth0
List = /etc/vxlan/all.ip
Address = ${vxlanip}/${PREFIX}
EOF

        cnt=`expr $cnt + 1`
done
}

case "$1" in
  "createvxlanconf" ) shift;createvxlanconf $*;;
  "createhosts" ) shift;createhosts $*;;
  "createsshkey" ) shift;createsshkey $*;;
esac
