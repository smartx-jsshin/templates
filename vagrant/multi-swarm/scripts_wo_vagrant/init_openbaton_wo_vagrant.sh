#!/bin/bash
export DEFAULT_USER="ubuntu"

install_basic_package(){
apt-get update
apt-get install -y vim git python
}

install_docker(){
apt-get remove -y docker docker-engine docker.io
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get -y update
apt-get -y install docker-ce
adduser $DEFAULT_USER docker
ln -s /var/run/docker/netns /var/run/netns
}

launch_openbaton_docker(){
OB_VER="${1:-5.0.0}"
sudo docker pull "openbaton/standalone:${OB_VER}"
sudo docker run --name openbaton -d --restart unless-stopped -h openbaton-rabbitmq \
    -p 8080:8080 -p 5672:5672 -p 15672:15672 -p 8443:8443 -e RABBITMQ_BROKERIP=127.0.0.1 \
    "openbaton/standalone:${OB_VER}"
}

if [ `id -u` -ne 0 ]; then
    echo "This script should be run with ROOT/SUDO PERMISSION"
    exit 1
fi

#install_basic_package
#install_docker
launch_openbaton_docker
