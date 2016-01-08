#!/bin/bash
# preoracle     preoracle init configuration
# chkconfig:    2345 20 80
# version:      0.1
# author:       s4ragent
MEMSIZE=1200m
SLEEP=30s
PRELOG=/var/log/tmpfs.log
case "$1" in
  start)
    touch /var/lock/subsys/tmpfs
    /bin/sleep $SLEEP >>$PRELOG 2>&1
    /bin/umount /dev/shm >>$PRELOG 2>&1
    /bin/mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=$MEMSIZE tmpfs /dev/shm >>$PRELOG 2>&1
    exit 0
    ;;
  stop)
    rm -f /var/lock/subsys/tmpfs
    ;;                                                                                                                                                                     
esac
