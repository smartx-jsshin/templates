#!/bin/bash

install_openvswitch(){
sudo apt-get install -y openvswitch-switch openvswitch-common
sudo ovs-appctl -t ovsdb-server ovsdb-server/add-remote ptcp:6640
sudo sed -i "s/^exit 0/ovs-appctl -t ovsdb-server ovsdb-server\/add-remote ptcp:6640 \nexit 0/g" /etc/rc.local
}

install_base_packages(){
sudo apt-get install -y wget curl screen unzip openjdk-8-jre
}

download_odl(){
sudo wget -O /root/distribution-karaf-0.6.1-Carbon.zip https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.1-Carbon/distribution-karaf-0.6.1-Carbon.zip
unzip /root/distribution-karaf-0.6.1-Carbon.zip -d /root/
}

execute_odl(){
sudo screen -dmS odl_control
sudo screen -S odl_control -X stuff $"cd /root/distribution-karaf-0.6.1-Carbon/; ./bin/karaf \n"
}

#install_openvswitch
#install_base_packages
#download_odl
#execute_odl
