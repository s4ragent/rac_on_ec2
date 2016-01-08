FROM oraclelinux:7
#enable epel
RUN yum -y install epel-release
#installpackages
RUN yum --enablerepo=ol7_addons -y install oracle-rdbms-server-12cR1-preinstall tar net-tools expect dnsmasq bind-utils
RUN yum -y reinstall glibc-common
RUN yum -y clean all

#createpreoracle
COPY preoracle.sh /usr/local/bin/preoracle.sh
COPY preoracle.service /etc/systemd/system/preoracle.service
RUN chmod 0700 /usr/local/bin/preoracle.sh
#RUN   systemctl enable preoracle.service

#disabletty
RUN systemctl stop getty@tty1.service &&\
    systemctl mask getty@tty1.service &&\
    systemctl stop serial-getty@ttyS0.service &&\
    systemctl mask serial-getty@ttyS0.service

#vxlan
COPY vxlan.init /usr/local/bin/vxlan.init
COPY vxlan.service /etc/systemd/system/vxlan.service
RUN chmod 0700 /usr/local/bin/vxlan.init
#RUN systemctl enablevxlan.service

ENTRYPOINT ["/sbin/init"]
