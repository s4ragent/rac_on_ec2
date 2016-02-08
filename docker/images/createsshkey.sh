#!/bin/bash
$WORK_DIR=/work
mkdir -p $WORK_DIR
BASE_IP=100

mkdir -p /work/
ssh-keygen -t rsa -P "" -f /work/id_rsa
hostkey=`cat /etc/ssh/ssh_host_rsa_key.pub`
for i in `seq 1 32`; do
    nodename="node"`printf "%.3d" $i`
    ip=`expr $BASE_IP + $i`
    echo "${nodename},"192.168.0.${ip}" $hostkey" >> /work/known_hosts
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
  
rm -rf /work
