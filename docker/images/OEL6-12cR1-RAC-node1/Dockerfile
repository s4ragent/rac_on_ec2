FROM s4ragent/oracle-rac:OEL6-prereq-12cR1-RAC
RUN /root/util.sh createvxlanfromhost node001 && chkconfig vxlan on && chkconfig retmpfs on && /root/util.sh changehostname node001
