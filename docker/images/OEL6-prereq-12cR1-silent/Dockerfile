FROM s4ragent/oracle-rac:OEL6-base
ENV MOUNT_PATH /u01
ENV ORA_ORACLE_BASE /u01/app/oracle
ENV ORA_ORACLE_HOME /u01/app/oracle/product/12.1.0/dbhome_1
ENV GRID_ORACLE_BASE /u01/app/grid
ENV GRID_ORACLE_HOME /u01/app/12.1.0/grid
ENV ORAINVENTORY /u01/app/oraInventory
RUN userdel -r oracle && groupdel dba && groupdel oinstall && \
    groupadd -g 54321 dba && groupadd -g 54322 oinstall && \
    groupadd -g 54323 asmdba && groupadd -g 54324 asmoper && groupadd -g 54325 asmadmin && \
    useradd -u 54321 -g oinstall -G dba,asmdba,asmadmin oracle && \
    useradd -u 54322 -g oinstall -G asmadmin,asmdba,asmoper grid && \
    useradd -u 54323 -g oinstall -G dba,asmdba,asmadmin oracleja && \
    useradd -u 54324 -g oinstall -G asmadmin,asmdba,asmoper gridja && \    
    echo "oracle:oracle123" | chpasswd && \
    echo "grid:grid123" | chpasswd && \
    echo "oracleja:oracle123" | chpasswd && \
    echo "gridja:grid123" | chpasswd  
RUN echo -e "#this is for oracle install#\n\
if [ -t 0 ]; then\n\
        stty intr ^C\n\
fi" >> /home/oracle/.bashrc && \
cat /home/oracle/.bashrc > /home/grid/.bashrc && \
cat /home/oracle/.bashrc > /home/oracleja/.bashrc && \
cat /home/oracle/.bashrc > /home/gridja/.bashrc
RUN echo -e "### for oracle install ####\n\
export ORACLE_BASE=${ORA_ORACLE_BASE}\n\
export ORACLE_HOME=${ORA_ORACLE_HOME}\n\
" >> /home/oracle/.bash_profile
RUN echo -e "export TMPDIR=/tmp\n\
export TEMP=/tmp\n\
export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/jdk/bin:\${PATH}\n\
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib\n\
" >> /home/oracle/.bash_profile && \
cat /home/oracle/.bash_profile > /home/oracleja/.bash_profile
RUN echo -e "### for oracle install ####\n\
export ORACLE_BASE=${GRID_ORACLE_BASE}\n\
export ORACLE_HOME=${GRID_ORACLE_HOME}\n\
" >> /home/grid/.bash_profile
RUN echo -e "export TMPDIR=/tmp\n\
export TEMP=/tmp\n\
export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/jdk/bin:\${PATH}\n\
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib\n\
" >> /home/grid/.bash_profile && \
cat /home/grid/.bash_profile > /home/gridja/.bash_profile
RUN sed -i 's/oracle/#oracle/' /etc/security/limits.d/oracle-rdbms-server-12cR1-preinstall.conf && \
sed -i 's/oracle/#oracle/' /etc/security/limits.conf && \
echo -e "\n\
oracle - nproc 16384\n\
oracle - nofile 65536\n\
oracle soft stack 10240\n\
grid - nproc 16384\n\
grid - nofile 65536\n\
grid soft stack 10240\n\
oracleja - nproc 16384\n\
oracleja - nofile 65536\n\
oracleja soft stack 10240\n\
gridja - nproc 16384\n\
gridja - nofile 65536\n\
gridja soft stack 10240\n\
" >> /etc/security/limits.conf
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/hosts /tmp/hosts
RUN echo -e "listen-address=127.0.0.1\n\
resolv-file=/etc/resolv.dnsmasq.conf\n\
conf-dir=/etc/dnsmasq.d\n\
user=root\n\
addn-hosts=/tmp/hosts\n\
" >> /etc/dnsmasq.conf
RUN echo -e "nameserver 8.8.8.8\n\
nameserver 8.8.4.4\n\
" >> /etc/resolv.dnsmasq.conf
## OEL7 systemctl enable dnsmasq
## OEL6 chkconfig dnsmasq on
RUN chkconfig dnsmasq on
RUN  mkdir ${MOUNT_PATH} && \
     chown grid:oinstall ${MOUNT_PATH} && \
     mkdir -p ${GRID_ORACLE_BASE} && \
     mkdir -p ${GRID_ORACLE_HOME} && \
     chown -R grid:oinstall ${MOUNT_PATH} && \
     mkdir -p ${ORA_ORACLE_BASE} && \
     chown oracle:oinstall ${ORA_ORACLE_BASE} && \
     chmod -R 775 ${MOUNT_PATH}
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/all.ip /etc/vxlan/all.ip
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/createvxlanconf.sh /root/createvxlanconf.sh
RUN chmod 755 /root/createvxlanconf.sh
