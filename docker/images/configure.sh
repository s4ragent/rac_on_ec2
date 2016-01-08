
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

rootfs_path=""
configure()
{

    # disable selinux in fedora
    mkdir -p $rootfs_path/selinux
    echo 0 > $rootfs_path/selinux/enforce

    # Also kill it in the /etc/selinux/config file if it's there...
    if [[ -f $rootfs_path/etc/selinux/config ]]
    then
        sed -i '/^SELINUX=/s/.*/SELINUX=disabled/' $rootfs_path/etc/selinux/config
    fi

    # Nice catch from Dwight Engen in the Oracle template.
    # Wantonly plagerized here with much appreciation.
    if [ -f $rootfs_path/usr/sbin/selinuxenabled ]; then
        mv $rootfs_path/usr/sbin/selinuxenabled $rootfs_path/usr/sbin/selinuxenabled.lxcorig
        ln -s /bin/false $rootfs_path/usr/sbin/selinuxenabled
    fi

    # This is a known problem and documented in RedHat bugzilla as relating
    # to a problem with auditing enabled.  This prevents an error in
    # the container "Cannot make/remove an entry for the specified session"
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' ${rootfs_path}/etc/pam.d/login
    sed -i '/^session.*pam_loginuid.so/s/^session/# session/' ${rootfs_path}/etc/pam.d/sshd

    if [ -f ${rootfs_path}/etc/pam.d/crond ]
    then
        sed -i '/^session.*pam_loginuid.so/s/^session/# session/' ${rootfs_path}/etc/pam.d/crond
    fi

    # In addition to disabling pam_loginuid in the above config files
    # we'll also disable it by linking it to pam_permit to catch any
    # we missed or any that get installed after the container is built.
    #
    # Catch either or both 32 and 64 bit archs.
    if [ -f ${rootfs_path}/lib/security/pam_loginuid.so ]
    then
        ( cd ${rootfs_path}/lib/security/
        mv pam_loginuid.so pam_loginuid.so.disabled
        ln -s pam_permit.so pam_loginuid.so
        )
    fi

    if [ -f ${rootfs_path}/lib64/security/pam_loginuid.so ]
    then
        ( cd ${rootfs_path}/lib64/security/
        mv pam_loginuid.so pam_loginuid.so.disabled
        ln -s pam_permit.so pam_loginuid.so
        )
    fi


    # Deal with some dain bramage in the /etc/init.d/halt script.
    # Trim it and make it our own and link it in before the default
    # halt script so we can intercept it.  This also preventions package
    # updates from interferring with our interferring with it.
    #
    # There's generally not much in the halt script that useful but what's
    # in there from resetting the hardware clock down is generally very bad.
    # So we just eliminate the whole bottom half of that script in making
    # ourselves a copy.  That way a major update to the init scripts won't
    # trash what we've set up.
    #
    # This is mostly for legacy distros since any modern systemd Fedora
    # release will not have this script so we won't try to intercept it.
    if [ -f ${rootfs_path}/etc/init.d/halt ]
    then
        sed -e '/hwclock/,$d' \
            < ${rootfs_path}/etc/init.d/halt \
            > ${rootfs_path}/etc/init.d/lxc-halt

        echo '$command -f' >> ${rootfs_path}/etc/init.d/lxc-halt
        chmod 755 ${rootfs_path}/etc/init.d/lxc-halt

        # Link them into the rc directories...
        (
             cd ${rootfs_path}/etc/rc.d/rc0.d
             ln -s ../init.d/lxc-halt S00lxc-halt
             cd ${rootfs_path}/etc/rc.d/rc6.d
             ln -s ../init.d/lxc-halt S00lxc-reboot
        )
    fi

    return 0
}

#OL6
configure_init()
{
    sed -i 's|.sbin.start_udev||' ${rootfs_path}/etc/rc.sysinit
    sed -i 's|.sbin.start_udev||' ${rootfs_path}/etc/rc.d/rc.sysinit
    # don't mount devpts, for pete's sake
    sed -i 's/^.*dev.pts.*$/#\0/' ${rootfs_path}/etc/rc.sysinit
    sed -i 's/^.*dev.pts.*$/#\0/' ${rootfs_path}/etc/rc.d/rc.sysinit
    chkconfig udev-post off
    chkconfig network on

    if [ -d ${rootfs_path}/etc/init ]
    then
       # This is to make upstart honor SIGPWR.  Should do no harm
       # on systemd systems and some systems may have both.
        cat <<EOF >${rootfs_path}/etc/init/power-status-changed.conf
#  power-status-changed - shutdown on SIGPWR
#
start on power-status-changed
    
exec /sbin/shutdown -h now "SIGPWR received"
EOF
    fi
}

#OL7
configure_fedora_systemd()
{
    rm -f ${rootfs_path}/etc/systemd/system/default.target
    touch ${rootfs_path}/etc/fstab
    ln -s /dev/null /etc/systemd/system/udev.service
    ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
    # Make systemd honor SIGPWR
    ln -s /usr/lib/systemd/system/halt.target /etc/systemd/system/sigpwr.target

    # if desired, prevent systemd from over-mounting /tmp with tmpfs
    if [ $masktmp -eq 1 ]; then
        chroot ${rootfs_path} ln -s /dev/null /etc/systemd/system/tmp.mount
    fi

    #dependency on a device unit fails it specially that we disabled udev
    # sed -i 's/After=dev-%i.device/After=/' ${rootfs_path}/lib/systemd/system/getty\@.service
    #
    # Actually, the After=dev-%i.device line does not appear in the
    # Fedora 17 or Fedora 18 systemd getty\@.service file.  It may be left
    # over from an earlier version and it's not doing any harm.  We do need
    # to disable the "ConditionalPathExists=/dev/tty0" line or no gettys are
    # started on the ttys in the container.  Lets do it in an override copy of
    # the service so it can still pass rpm verifies and not be automatically
    # updated by a new systemd version.  --  mhw  /\/\|=mhw=|\/\/

    sed -e 's/^ConditionPathExists=/# ConditionPathExists=/' \
        -e 's/After=dev-%i.device/After=/' \
        < ${rootfs_path}/lib/systemd/system/getty\@.service \
        > ${rootfs_path}/etc/systemd/system/getty\@.service
}
