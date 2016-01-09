FROM oraclelinux:6
#configure for container
RUN mkdir -p /selinux &&\
    echo 0 > /selinux/enforce &&\
    mv /usr/sbin/selinuxenabled /usr/sbin/selinuxenabled.lxcorig &&\
    ln -s /bin/false /usr/sbin/selinuxenabled &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/login &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/sshd &&
WORKDIR /lib64/security/
RUN mv pam_loginuid.so pam_loginuid.so.disabled &&\
    ln -s pam_permit.so pam_loginuid.so
RUN sed -e '/hwclock/,$d' < /etc/init.d/halt > /etc/init.d/lxc-halt &&\
    echo '$command -f' >> /etc/init.d/lxc-halt &&\
    chmod 755 /etc/init.d/lxc-halt
WORKDIR /etc/rc.d/rc0.d
RUN ln -s ../init.d/lxc-halt S00lxc-halt
WORKDIR /etc/rc.d/rc6.d
RUN ln -s ../init.d/lxc-halt S00lxc-reboot
RUN sed -i 's|.sbin.start_udev||' /etc/rc.sysinit &&\
    sed -i 's|.sbin.start_udev||' /etc/rc.d/rc.sysinit &&\
    sed -i 's/^.*dev.pts.*$/#\0/' /etc/rc.sysinit &&\
    sed -i 's/^.*dev.pts.*$/#\0/' /etc/rc.d/rc.sysinit &&\
    chkconfig udev-post off &&\
    chkconfig network on &&\
    echo "start on power-status-changed" > /etc/init/power-status-changed.conf &&\
    echo "" >>  /etc/init/power-status-changed.conf &&\
    echo 'exec /sbin/shutdown -h now "SIGPWR received"' >> /etc/init/power-status-changed.conf
#disabletty
RUN 	mv /etc/init/tty.conf /etc/init/tty.bk; mv /etc/init/serial.conf /etc/init/serial.bk
#enable epel
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#installpackages
RUN yum -y install git\
                   traceroute\
                   unzip\
                   iperf\
                   oracle-rdbms-server-12cR1-preinstall\
                   screen\
                   nfs-utils\
                   dnsmasq\
                   firefox.x86_64\
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
                   bind-utils
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
#
WORKDIR /
RUN rm -rf iproute2
VOLUME [ “/sys/fs/cgroup” ]
CMD ["/sbin/init"]
