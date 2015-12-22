#sudo su
#yum -y install git
parted /dev/xvdf --script 'mklabel msdos mkpart primary 1M -1s print quit'
partprobe /dev/xvdf
udevadm settle
mkfs.ext4 /dev/xvdf1
mkdir -p /mnt
mount /dev/xvdf1 /mnt

cd /mnt
mkdir etc proc dev
cp /etc/fstab /mnt/etc/fstab

mount -t proc none proc


mkdir /mnt/etc/yum.repos.d/
mv /etc/yum.repos.d /etc/yum.repos.d.bak
curl -L -o /mnt/etc/yum.repos.d/public-yum-ol6.repo http://public-yum.oracle.com/public-yum-ol6.repo
cp /etc/yum.conf /mnt/etc/

wget http://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
yum -c /mnt/etc/yum.repos.d/public-yum-ol6.repo --installroot=/mnt -y groupinstall Core 
yum -c /mnt/etc/yum.repos.d/public-yum-ol6.repo --installroot=/mnt -y install kernel ruby rsync grub 

cd /mnt
cp -a /dev/xvdf /dev/xvdf1 /mnt/dev/
cp /mnt/usr/*/grub/*/*stage* /mnt/boot/grub/


cd /mnt
cat > boot/grub/menu.lst <<EOS
default=0
timeout=0
hiddenmenu
title oraclelinux6
        root (hd0,0)
        kernel /boot/vmlinuz-$(rpm --root=$PWD -q --queryformat "%{version}-%{release}.%{arch}\n" kernel) ro root=LABEL=/ console=ttyS0 xen_pv_hvm=enable
        initrd /boot/initramfs-$(rpm --root=$PWD -q --queryformat "%{version}-%{release}.%{arch}\n" kernel).img
EOS


chroot /mnt /bin/bash -c "ln -s /boot/grub/menu.lst /boot/grub/grub.conf;ln -s /boot/grub/grub.conf /etc/grub.conf"


cat <<EOF | chroot /mnt grub --batch
device (hd0) /dev/xvdf
root (hd0,0)
setup (hd0)
EOF

e2label /dev/xvdf1 /

rm -f /mnt/dev/xvdf /mnt/dev/xvdf1

cat > /mnt/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
TYPE=Ethernet
USERCTL=yes
PEERDNS=yes
IPV6INIT=no
EOF

cat > /mnt/etc/sysconfig/network-scripts/route-eth0 <<EOF
169.254.0.0/16 dev eth0  scope link  metric 1
EOF

cat > /mnt/etc/sysconfig/network <<EOF
NETWORKING=yes
EOF

cat > /mnt/etc/rc.local <<'EOF'
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local

if [ ! -d /root/.ssh ]; then
mkdir -p /root/.ssh
chmod 700 /root/.ssh
fi
# Fetch public key using HTTP
ATTEMPTS=30
FAILED=0
rm -rf /root/.ssh/authorized_keys
while [ ! -f /root/.ssh/authorized_keys ]; do
curl -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /tmp/metadata-key 2>/dev/null
if [ $? -eq 0 ]; then
cat /tmp/metadata-key >> /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
restorecon /root/.ssh/authorized_keys
rm -f /tmp/metadata-key
echo "Successfully retrieved public key from instance metadata"
echo "*****************"
echo "AUTHORIZED KEYS"
echo "*****************"
cat /root/.ssh/authorized_keys
echo "*****************"
else
FAILED=`expr $FAILED + 1`
if [ $FAILED -ge $ATTEMPTS ]; then
echo "Failed to retrieve public key from instance metadata after $FAILED attempts, quitting"
break
fi
echo "Could not retrieve public key from instance metadata (attempt #$FAILED/$ATTEMPTS), retrying in 5 seconds..."
sleep 5
fi
done

EOF

cd /mnt
perl -p -i -e 's,^#PermitRootLogin yes,PermitRootLogin without-password,' etc/ssh/sshd_config
perl -p -i -e 's,^#UseDNS yes,UseDNS no,' etc/ssh/sshd_config
perl -p -i -e 's,^PasswordAuthentication yes,PasswordAuthentication no,' etc/ssh/sshd_config
sed -i "s/enforcing/disabled/" /mnt/etc/sysconfig/selinux

chroot /mnt /bin/bash -c "rpm -vv --rebuilddb >/dev/null 2>&1;touch .autorelabel"


sync;sync;sync;
cd
umount /mnt/proc
umount /mnt


