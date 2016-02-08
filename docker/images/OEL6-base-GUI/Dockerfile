FROM s4ragent/oracle-rac:OEL6-base
RUN yum -y groupinstall Xfce "Japanese Support" && yum -y install xrdp tigervnc-server firefox && yum -y clean all
RUN chkconfig xrdp on && chkconfig iptables off
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/Xclients /etc/skel/.Xclients
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/Xclients /etc/skel/.Xclients-ja
RUN chmod +x /etc/skel/.Xclients
RUN chmod +x /etc/skel/.Xclients-ja
ADD https://raw.githubusercontent.com/s4ragent/RAC-on-XX/master/docker/images/km-e0010411.ini /etc/xrdp/km-e0010411.ini
RUN cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-0411.ini &&\
    cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-e0200411.ini &&\
    cp /etc/xrdp/km-e0010411.ini /etc/xrdp/km-e0210411.ini
