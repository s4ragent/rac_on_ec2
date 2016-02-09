FROM s4ragent/oracle-rac:OEL6-prereq-12cR1-GUI
#https://oracle-base.com/articles/12c/oracle-db-12cr1-rac-installation-on-oracle-linux-6-using-nfs
RUN mkdir /shared_config &&\
    mkdir /shared_grid &&\
    mkdir /shared_home &&\
    mkdir /shared_data
RUN echo -e "#for asm#\n\
/shared_config               *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
/shared_grid                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
/shared_home                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
/shared_data                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
" >> /etc/exports
RUN chkconfig nfs on && service nfs restart
RUN /root/createvxlanconf.sh 33
