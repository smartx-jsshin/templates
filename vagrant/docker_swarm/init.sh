#!/bin/bash
export DEFAULT_USER="ubuntu"

apt-get update
apt-get install -y vim git 

apt-get remove -y docker docker-engine docker.io
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get -y update
sudo apt-get -y install docker-ce
adduser $DEFAULT_USER docker
sudo ln -s /var/run/docker/netns /var/run/netns
