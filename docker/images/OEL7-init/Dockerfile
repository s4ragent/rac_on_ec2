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
        < /lib/systemd/system/getty\@.service > /etc/systemd/system/getty\@.service &&\
    ln -s /dev/null /etc/systemd/system/getty@tty1.service &&\
    ln -s /dev/null /etc/systemd/system/serial-getty@ttyS0.service
VOLUME [ “/sys/fs/cgroup” ]
CMD ["/sbin/init"]
