FROM oraclelinux:6
#configure for container
RUN mkdir -p /selinux &&\
    echo 0 > /selinux/enforce &&\
    mv /usr/sbin/selinuxenabled /usr/sbin/selinuxenabled.lxcorig &&\
    ln -s /bin/false /usr/sbin/selinuxenabled &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/login &&\
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' /etc/pam.d/sshd
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
WORKDIR /
CMD ["/sbin/init"]
