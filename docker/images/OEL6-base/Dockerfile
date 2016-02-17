FROM oraclelinux:6
#install epel
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#installpackages
RUN yum -y groupinstall Xfce "Japanese Support" &&\
    yum -y install git\
                   traceroute\
                   unzip\
                   iperf\
                   oracle-rdbms-server-12cR1-preinstall\
                   screen\
                   nfs-utils\
                   dnsmasq\
                   git\
                   bison\
                   flex\
                   db4-devel\
                   libselinux-python\
                   python-pip\
                   ansible\
                   tar\
                   net-tools\
                   expect\
                   bind-utils\
                   xrdp\
                   tigervnc-server\
                   firefox
RUN yum -y reinstall glibc-common
RUN yum -y clean all
#iproute2
RUN git clone git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git 
WORKDIR iproute2
RUN git checkout v3.17.0 && ./configure && make && make DESTDIR=/usr/share install
#createpreoracle
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/retmpfs.sh /usr/local/bin/retmpfs.sh
RUN install -o root -g root -m 755 /usr/local/bin/retmpfs.sh /etc/init.d/retmpfs

#vxlan
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/vxlan.init /usr/local/bin/vxlan.init
RUN sed -i -e "s/\/sbin\/ip/\/usr\/share\/sbin\/ip/g" /usr/local/bin/vxlan.init
RUN sed -i -e "s/\/sbin\/bridge/\/usr\/share\/sbin\/bridge/g" /usr/local/bin/vxlan.init
RUN install -o root -g root -m 755 /usr/local/bin/vxlan.init /etc/init.d/vxlan
RUN mkdir /etc/vxlan

#xrdp
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/Xclients /etc/skel/.Xclients
RUN chmod +x /etc/skel/.Xclients
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/km-e0010411.ini /etc/xrdp/km-e0010411.ini
RUN cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-0411.ini &&\
    cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-e0200411.ini &&\
    cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-e0210411.ini

WORKDIR /
RUN rm -rf iproute2
RUN mv /etc/init/tty.conf /etc/init/tty.bk; mv /etc/init/serial.conf /etc/init/serial.bk
CMD ["/sbin/init"]
