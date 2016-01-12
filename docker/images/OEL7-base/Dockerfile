FROM s4ragent/oracle-rac:OEL7-init
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

VOLUME [ “/sys/fs/cgroup” ]
CMD ["/sbin/init"]
