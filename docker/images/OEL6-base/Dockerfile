FROM oraclelinux:6
#installpackages
RUN yum -y install git bison flex db4-devel oracle-rdbms-server-12cR1-preinstall tar net-tools expect dnsmasq bind-utils
RUN git clone git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git 
WORKDIR iproute2
RUN git checkout v3.17.0 && ./configure && make && make DESTDIR=/usr/share install
#createpreoracle
COPY preoracle.sh /usr/local/bin/preoracle.sh
RUN  install -o root -g root -m 755 /usr/local/bin/preoracle.sh /etc/init.d/preoracle
#disabletty
RUN 	mv /etc/init/tty.conf /etc/init/tty.bk; mv /etc/init/serial.conf /etc/init/serial.bk
#vxlan
COPY vxlan.init /usr/local/bin/vxlan.init
RUN  install -o root -g root -m 755 /usr/local/bin/vxlan.init /etc/init.d/vxlan
#
ENTRYPOINT ["/sbin/init"]
