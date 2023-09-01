FROM telegraf:1.27

ARG AUTOLOAD_MIBS="rfc ianarfc iana"

RUN export  DEBIAN_FRONTEND=noninteractive && \
    export DEBIAN_RELEASE=$(awk -F'[" ]' '/VERSION=/{print $3}'  /etc/os-release | tr -cd '[[:alnum:]]._-' ) && \
    echo "Release is '${DEBIAN_RELEASE}'" && \
    echo "deb http://httpredir.debian.org/debian ${DEBIAN_RELEASE} main contrib non-free"  >> /etc/apt/sources.list && \
    echo "deb http://httpredir.debian.org/debian ${DEBIAN_RELEASE}-updates main contrib non-free"  >> /etc/apt/sources.list && \
    set -ex && \
    apt-get update && \
    apt-get -y install snmp-mibs-downloader && \
    echo 'BASEDIR=/var/lib/snmp/mibs \n \
    AUTOLOAD="${AUTOLOAD_MIBS}"\n' > /etc/snmp-mibs-downloader/snmp-mibs-downloader.conf && \
    download-mibs && \
    rm -r /var/lib/apt/lists/*