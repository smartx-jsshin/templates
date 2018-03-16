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

enable_swarm_remote_access(){
sudo mkdir -p /lib/systemd/system/docker.service.d

echo "[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://${SWARM_CTRL_IPADDR}:2375 --insecure-registry ${SWARM_CTRL_IPADDR}:5000" | sudo tee /lib/systemd/system/docker.service.d/remote-access.conf

systemctl daemon-reload
systemctl restart docker.service
}

execute_docker_registry(){
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker tag registry:2 ${SWARM_CTRL_IPADDR}:5000/registry
docker push ${SWARM_CTRL_IPADDR}:5000/registry
}

load_test_image_to_docker_registry(){
docker pull jsshin1230/test_image
docker tag jsshin1230/test_image ${SWARM_CTRL_IPADDR}:5000/test_image
docker push ${SWARM_CTRL_IPADDR}:5000/test_image
}

export SWARM_CTRL_IPADDR=$1


if [ `id -u` -ne 0 ]; then
    echo "This script should be run with ROOT/SUDO PERMISSION"
    exit 1
fi

if [ -z ${SWARM_CTRL_IPADDR} ]; then
    echo "IP address of this box is not passed. You should specify it as the fisrt parameter"
    exit 1
fi

install_basic_package
install_docker
enable_swarm_remote_access
execute_docker_registry
load_test_image_to_docker_registry
