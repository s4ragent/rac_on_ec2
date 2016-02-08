FROM s4ragent/oracle-rac:OEL6-prereq-12cR1-silent
RUN mkdir -p /oracleasm/config && RUN mkdir -p /oracleasm/data
RUN echo -e "#for asm#\n\
/oracleasm/config               *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
/oracleasm/data                 *(rw,sync,no_wdelay,insecure_locks,no_root_squash)
" >> /etc/exports
RUN chkconfig nfs on && service nfs restart
RUN /root/createvxlanconf.sh 60
