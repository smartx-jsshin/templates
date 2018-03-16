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

install_basic_package
install_docker

echo "============================================================================"
echo "Connect Docker Engine in this host to Docker Swarm Manager by following steps"
echo "	1. In the manager, execute a command \"docker swarm join-worker\""
echo "	2. Copy the output of the command"
echo "	3. In the manager, executing the copied command"
echo "============================================================================"
