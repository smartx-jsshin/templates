# Install docker...
install_basic_package(){
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl \
                     software-properties-common
}

install_docker(){
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker ubuntu
}

launch_openbaton_docker(){
OB_VER="${1:-5.0.0}"
# Runs OpenBaton Docker
sudo docker pull "openbaton/standalone:${OB_VER}"
sudo docker run --name openbaton -d -h openbaton-rabbitmq \
    -p 8080:8080 -p 5672:5672 -p 15672:15672 -p 8443:8443 -e RABBITMQ_BROKERIP=127.0.0.1 \
    "openbaton/standalone:${OB_VER}"
}

install_java(){
sudo apt-get install -y openjdk-8-jdk
}

install_basic_package
install_docker
launch_openbaton_docker "5.0.0"
install_java
