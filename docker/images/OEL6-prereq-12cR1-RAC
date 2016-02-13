FROM s4ragent/oracle-rac:OEL6-prereq-12cR1
RUN echo -e "### for oracle install ####\n\
nas1:/shared_config $MOUNT_PATH/shared_config  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_grid   $GRID_ORACLE_HOME  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_home   $ORA_ORACLE_HOME  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_data   $MOUNT_PATH/oradata  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
" >> /etc/fstab
