#!/bin/bash

install_basic_package(){
sudo apt-get update
}

install_ansible(){
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

# Conigure Ansible
sudo sed -i "/^\[defaults\]/a host_key_checking = False" /etc/ansible/ansible.cfg
}

download_playbooks(){
git clone https://github.com/smartx-jsshin/templates.git
}

prepare_sshkey(){
ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
mkdir -p ${HOME}/.ssh
cp ${HOME}/.ssh/id_rsa.pub /vagrant/post_key.pub
}

install_basic_package
install_ansible
download_playbooks
prepare_sshkey
