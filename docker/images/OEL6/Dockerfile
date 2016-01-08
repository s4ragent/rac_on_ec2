FROM oraclelinux:6
RUN yum -y install git bison flex db4-devel && git clone git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git && git checkout v3.17.0 && ./configure && make && make
