# Based on https://github.com/weldpua2008/docker-net-snmp
FROM telegraf:1.27

RUN export  DEBIAN_FRONTEND=noninteractive && \
export DEBIAN_RELEASE=$(awk -F'[" ]' '/VERSION=/{print $3}'  /etc/os-release | tr -cd '[[:alnum:]]._-' ) && \
echo "remove main from /etc/apt/sources.list" && \
sed -i '/main/d' /etc/apt/sources.list && \
echo "remove contrib from /etc/apt/sources.list" && \
sed -i '/contrib/d' /etc/apt/sources.list && \
echo "remove non-free from /etc/apt/sources.list" && \
sed -i '/non-free/d' /etc/apt/sources.list && \
echo "deb http://httpredir.debian.org/debian ${DEBIAN_RELEASE} main contrib non-free"  >> /etc/apt/sources.list && \
echo "deb http://httpredir.debian.org/debian ${DEBIAN_RELEASE}-updates main contrib non-free"  >> /etc/apt/sources.list && \
echo "deb http://security.debian.org ${DEBIAN_RELEASE}/updates main contrib non-free"  >> /etc/apt/sources.list && \
set -x &&\
apt-get update && \
apt-get -y install snmp-mibs-downloader && \
echo 'BASEDIR=/var/lib/snmp/mibs \n\
AUTOLOAD="rfc ianarfc iana cisco\n"' > /etc/snmp-mibs-downloader/snmp-mibs-downloader.conf &&\
echo "mibdirs +/usr/share/snmp/mibs/cisco" >> /etc/snmp/snmp.conf &&\
ln -s /var/lib/snmp/mibs/cisco /usr/share/snmp/mibs/cisco &&\
download-mibs &&\
rm -r /var/lib/apt/lists/*
