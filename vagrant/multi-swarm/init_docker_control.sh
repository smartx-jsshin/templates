#!/bin/bash

configure_docker(){
sudo mkdir -p /lib/systemd/system/docker.service.d

echo "[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://${SWARM_CTRL_IPADDR}:2375 --insecure-registry ${SWARM_CTRL_IPADDR}:5000" | sudo tee /lib/systemd/system/docker.service.d/remote-access.conf

sudo systemctl daemon-reload
sudo systemctl restart docker.service
}

execute_docker_registry(){
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker tag registry:2 ${SWARM_CTRL_IPADDR}:5000/registry
docker push ${SWARM_CTRL_IPADDR}:5000/registry
}

pull_spark_images(){
# Download Spark Manager Image
docker pull soehue/zeppelin_spark 
docker tag soehue/zeppelin_spark ${SWARM_CTRL_IPADDR}:5000/zeppelin_spark 
docker push ${SWARM_CTRL_IPADDR}:5000/zeppelin_spark 

# Download Spark Worker Image
docker pull soehue/spark 
docker tag soehue/spark ${SWARM_CTRL_IPADDR}:5000/spark
docker push ${SWARM_CTRL_IPADDR}:5000/spark
}

load_test_image_to_docker_registry(){
docker pull jsshin1230/test_image
docker tag jsshin1230/test_image ${SWARM_CTRL_IPADDR}:5000/test_image
docker push ${SWARM_CTRL_IPADDR}:5000/test_image
}

export SWARM_CTRL_IPADDR=$1

if [ -z ${SWARM_CTRL_IPADDR} ]; then
    echo "IP address of this box is not passed. You should specify it as the fisrt parameter"
    exit 1
fi

configure_docker
execute_docker_registry
#pull_spark_images
load_test_image_to_docker_registry
