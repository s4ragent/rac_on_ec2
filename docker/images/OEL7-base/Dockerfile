FROM oraclelinux:7
#enable epel
RUN yum -y install epel-release
#installpackages
RUN yum --enablerepo=ol7_addons -y install oracle-rdbms-server-12cR1-preinstall tar net-tools expect dnsmasq bind-utils
RUN yum -y reinstall glibc-common
RUN yum -y clean all
#createpreoracle
COPY preoracle.sh /usr/local/bin/preoracle.sh
RUN  install -o root -g root -m 755 /usr/local/bin/preoracle.sh /etc/init.d/preoracle


#disabletty
RUN 	mv /etc/init/tty.conf /etc/init/tty.bk; mv /etc/init/serial.conf /etc/init/serial.bk
#vxlan
COPY vxlan.init /usr/local/bin/vxlan.init
RUN  install -o root -g root -m 755 /usr/local/bin/vxlan.init /etc/init.d/vxlan
#
WORKDIR /
RUN rm -rf iproute2
ENTRYPOINT ["/sbin/init"]
