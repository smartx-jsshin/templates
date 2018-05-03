#!/bin/bash

if [ `id -u` -ne 0 ]; then
	echo "This script should be executed with Root privileges"
	exit 1
fi

apt-get update
apt-get install -y make gcc libc-dev build-essential wget tar

wget https://www.openfabrics.org/downloads/qperf/qperf-0.4.9.tar.gz
tar xvf qperf-0.4.9.tar.gz

cd qperf-0.4.9
./configure
make install

apt-get install -y bc
wget https://raw.githubusercontent.com/smartx-jsshin/templates/master/bash/networking_test/test_qperf.sh
