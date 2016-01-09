FROM oraclelinux:7
##configure for containers
RUN mkdir -p /selinux &&\
    echo 0 > /selinux/enforce &&\
    mv /usr/sbin/selinuxenabled /usr/sbin/selinuxenabled.lxcorig &&\
    ln -s /bin/false /usr/sbin/selinuxenabled &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/login &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/sshd
WORKDIR /lib64/security/
RUN mv pam_loginuid.so pam_loginuid.so.disabled &&\
    ln -s pam_permit.so pam_loginuid.so
RUN rm -f /etc/systemd/system/default.target &&\
    touch /etc/fstab &&\
    ln -s /dev/null /etc/systemd/system/udev.service &&\
    ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target &&\
    ln -s /usr/lib/systemd/system/halt.target /etc/systemd/system/sigpwr.target &&\
    sed -e 's/^ConditionPathExists=/# ConditionPathExists=/' \
        -e 's/After=dev-%i.device/After=/' \
        < /lib/systemd/system/getty\@.service > /etc/systemd/system/getty\@.service
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
