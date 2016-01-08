FROM oraclelinux:6
#installpackages
RUN yum -y install git bison flex db4-devel oracle-rdbms-server-12cR1-preinstall tar net-tools expect dnsmasq bind-utils
RUN git clone git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git 
WORKDIR iproute2
RUN git checkout v3.17.0 && ./configure && make && make DESTDIR=/usr/share install
#delete&create group/user
RUN userdel -r oracle;\
    userdel -r grid;\
    groupdel dba;\
    groupdel oinstall;\
    groupdel oper;\
    groupdel asmadmin;\
    groupdel asmdba;\
    groupdel asmoper;\
    groupadd -g 601 oinstall &&\
    groupadd -g 602 dba &&\
    groupadd -g 603 oper &&\
    groupadd -g 1001 asmadmin &&\
    groupadd -g 1002 asmdba &&\
    groupadd -g 1003 asmoper&&\
    useradd -u 501 -m -g oinstall -G dba,oper,asmdba -d /home/oracle -s /bin/bash -c"Oracle Software Owner" oracle &&\
    useradd -u 1001 -m -g oinstall -G asmadmin,asmdba,asmoper -d /home/grid -s /bin/bash -c "Grid Infrastructure Owner" grid
#enableping
RUN chmod u+s /usr/bin/ping
#createdns
#createrules
#createpreoracle
#disabletty
RUN 	mv /etc/init/tty.conf /etc/init/tty.bk; mv /etc/init/serial.conf /etc/init/serial.bk
