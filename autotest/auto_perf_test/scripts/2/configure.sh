#!/bin/bash
# Test Case 2
# 2 Boxes, 2 Containers, Through Internet (L3 Networking)

modify_configuration(){
sed -i "s/<box1_name>/nettest-control1-1/g" ./test.cfg
sed -i "s/<box2_name>/nettest-control2-1/g" ./test.cfg
sed -i "s/<container1_name>/test_con1/g" ./test.cfg
sed -i "s/<container2_name>/test_con2/g" ./test.cfg
sed -i "s/<container1_subnet>/192.168.10.0\/24/g" ./test.cfg
sed -i "s/<container2_subnet>/192.168.11.0\/24/g" ./test.cfg
sed -i "s/<container1_ip>/192.168.10.101/g" ./test.cfg
sed -i "s/<container2_ip>/192.168.11.102/g" ./test.cfg
}

create_docker_network(){
vagrant ssh "${box1_name}" -c "docker network create --subnet ${container1_subnet} -d overlay test_net"
if [ "${box1_name}" -ne "${box2_name}" ];then
vagrant ssh "${box2_name}" -c "docker network create --subnet ${container2_subnet} -d overlay test_net"
fi
}

connects_two_overlay_networks(){
echo "Not implemented yet ;("
}

instantiate_containers(){
vagrant ssh "${box1_name}" -c "docker container run -tid --network test_net --ip ${container1_ip} --name ${container1_name} -P jsshin1230/test_image"
vagrant ssh "${box2_name}" -c "docker container run -tid --network test_net --ip ${container2_ip} --name ${container2_name} -P jsshin1230/test_image"
}

modify_configuration
source ./test.cfg
create_docker_network
connects_two_overlay_networks
instantiate_containers
