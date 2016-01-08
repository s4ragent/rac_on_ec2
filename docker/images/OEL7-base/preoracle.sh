#!/bin/bash
# preoracle     preoracle init configuration
# chkconfig:    2345 20 80
# version:      0.1
# author:       s4ragent
PRELOG=/var/log/preoracle.log
case "$1" in
  start)
    touch /var/lock/subsys/preoracle
    /bin/sleep 30s >>$PRELOG 2>&1
    /bin/umount /dev/shm >>$PRELOG 2>&1
    /bin/mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=1200m tmpfs /dev/shm >>$PRELOG 2>&1
    exit 0
    ;;
  stop)
    rm -f /var/lock/subsys/preoracle
    ;;                                                                                                                                                                     
esac
