FROM s4ragent/oracle-rac:OEL6-base-GUI
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
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/all.ip /etc/vxlan/all.ip
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/util.sh /root/util.sh
RUN chmod 755 /root/util.sh
RUN /root/util.sh createsshkey
RUN /root/util.sh createhosts
