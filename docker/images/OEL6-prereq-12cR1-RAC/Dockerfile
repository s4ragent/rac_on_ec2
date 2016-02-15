FROM s4ragent/oracle-rac:OEL6-prereq-12cR1
ENV MOUNT_PATH /u01
ENV ORA_ORACLE_BASE /u01/app/oracle
ENV ORA_ORACLE_HOME /u01/app/oracle/product/12.1.0/dbhome_1
ENV GRID_ORACLE_BASE /u01/app/grid
ENV GRID_ORACLE_HOME /u01/app/12.1.0/grid
ENV ORAINVENTORY /u01/app/oraInventory
RUN echo -e "### for oracle install ####\n\
nas1:/shared_config $MOUNT_PATH/shared_config  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_grid   $GRID_ORACLE_HOME  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_home   $ORA_ORACLE_HOME  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
nas1:/shared_data   $MOUNT_PATH/oradata  nfs  rw,bg,hard,nointr,tcp,vers=3,timeo=600,rsize=32768,wsize=32768,actimeo=0  0 0 \n\
" >> /etc/fstab
RUN mkdir -p $MOUNT_PATH/shared_config &&\
    chown grid:oinstall $MOUNT_PATH/shared_config &&\
    mkdir -p $ORA_ORACLE_HOME &&\
    chown oracle:oinstall $ORA_ORACLE_HOME &&\
    mkdir -p $MOUNT_PATH/oradata &&\
    chown grid:oinstall $MOUNT_PATH/oradata
