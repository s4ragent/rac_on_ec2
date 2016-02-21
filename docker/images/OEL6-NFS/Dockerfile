FROM s4ragent/oracle-rac:OEL6-prereq-Common
#https://oracle-base.com/articles/12c/oracle-db-12cr1-rac-installation-on-oracle-linux-6-using-nfs
RUN mkdir /asm_disk &&\
    mkdir /shared_grid &&\
    mkdir /shared_home
RUN echo -e "#for asm#\n\
/shared_asm_disk               *(rw,sync,no_wdelay,insecure_locks,no_root_squash) \n\
/shared_grid                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash) \n\
/shared_home                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash) \n\
" >> /etc/exports
RUN chown grid:oinstall /asm_disk &&\
    chmod 775 /asm_disk &&\
    chown grid:oinstall /shared_grid &&\
    chmod 775 /shared_grid &&\
    chown oracle:oinstall /shared_home &&\
    chmod 775 /shared_home
RUN chkconfig nfs on
RUN echo "/etc/init.d/nfs restart" >> /etc/rc.d/rc.local
