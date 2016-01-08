FROM oraclelinux:7

#disable selinux
RUN mkdir -p /selinux &&\
    echo 0 > /selinux/enforce &&\
    mkdir -p /etc/selinux &&\
    echo "SELINUX=disabled" >/etc/selinux/config

#enable epel
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#installpackages
RUN yum --enablerepo=ol7_addons -y install oracle-rdbms-server-12cR1-preinstall tar net-tools expect dnsmasq bind-utils
RUN yum -y reinstall glibc-common
RUN yum -y clean all

#createpreoracle
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/retmpfs.sh /usr/local/bin/retmpfs.sh
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/retmpfs.service /etc/systemd/system/retmpfs.service
RUN chmod 0700 /usr/local/bin/retmpfs.sh
#RUN   systemctl enable preoracle.service

#vxlan
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/vxlan.init /usr/local/bin/vxlan.init
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/vxlan.service /etc/systemd/system/vxlan.service
RUN chmod 0700 /usr/local/bin/vxlan.init
RUN mkdir /etc/vxlan
#RUN systemctl enablevxlan.service

RUN rm -f /etc/systemd/system/default.target
RUN touch ${rootfs_path}/etc/fstab
RUN ln -s /dev/null /etc/systemd/system/udev.service
RUN ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
# Make systemd honor SIGPWR
RUN ln -s /usr/lib/systemd/system/halt.target /etc/systemd/system/sigpwr.target

RUN sed -e 's/^ConditionPathExists=/# ConditionPathExists=/' \
        -e 's/After=dev-%i.device/After=/' \
        < /lib/systemd/system/getty\@.service \
        > /etc/systemd/system/getty\@.service

VOLUME [ “/sys/fs/cgroup” ]
CMD ["/sbin/init"]
