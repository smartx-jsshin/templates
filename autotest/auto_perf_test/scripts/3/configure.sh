#!/bin/bash
# Test Case 3
# 2 Boxes, 2 Containers, Manually configured Overlay networking

modify_configuration(){
sed -i "s/<box1_name>/nettest-control1-1/g" ./test.cfg
sed -i "s/<box2_name>/nettest-control1-2/g" ./test.cfg
sed -i "s/<container1_name>/test_con1/g" ./test.cfg
sed -i "s/<container2_name>/test_con2/g" ./test.cfg
sed -i "s/<container1_subnet>/192.168.10.0\/24/g" ./test.cfg
sed -i "s/<container2_subnet>/192.168.10.0\/24/g" ./test.cfg
sed -i "s/<container1_ip>/192.168.10.101/g" ./test.cfg
sed -i "s/<container2_ip>/192.168.10.102/g" ./test.cfg
}

create_docker_network(){
vagrant ssh "${box1_name}" -c "docker network create --subnet ${container1_subnet} -d bridge test_net"
if [ "${box1_name}" != "${box2_name}" ];then
vagrant ssh "${box2_name}" -c "docker network create --subnet ${container2_subnet} -d bridge test_net"
fi
}

instantiate_containers(){
vagrant ssh "${box1_name}" -c "docker container run -tid --network test_net --ip ${container1_ip} --name ${container1_name} jsshin1230/test_image"
vagrant ssh "${box2_name}" -c "docker container run -tid --network test_net --ip ${container2_ip} --name ${container2_name} jsshin1230/test_image"
}

modify_vxlan_scripts(){
#vagrant ssh "${box1_name}" -c "sudo sh -c 'ln -s /var/run/docker/netns /var/run/netns'"
#vagrant ssh "${box2_name}" -c "sudo sh -c 'ln -s /var/run/docker/netns /var/run/netns'"
container1_mac=`vagrant ssh "${box1_name}" -c "docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' ${container1_name} | tr -d '\n'"`
container2_mac=`vagrant ssh "${box2_name}" -c "docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' ${container2_name} | tr -d '\n'"`
box1_ip=`vagrant ssh "${box1_name}" -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'"`
box2_ip=`vagrant ssh "${box2_name}" -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//' | tr -d '\n'"`

sed -i "s/<other_con_ip>/${container2_ip}/g" vxlan_box1.sh
sed -i "s/<other_con_mac>/${container2_mac}/g" vxlan_box1.sh
sed -i "s/<other_box_ip>/${box2_ip}/g" vxlan_box1.sh

sed -i "s/<other_con_ip>/${container1_ip}/g" vxlan_box2.sh
sed -i "s/<other_con_mac>/${container1_mac}/g" vxlan_box2.sh
sed -i "s/<other_box_ip>/${box1_ip}/g" vxlan_box2.sh
}

execute_vxlan_scripts(){
vagrnat ssh "${box1_name}" -c "sudo bash /vagrant/vxlan_box1.sh"
vagrant ssh "${box2_name}" -c "sudo bash /vagrant/vxlan_box2.sh"
}

modify_configuration
source ./test.cfg
create_docker_network
instantiate_containers
modify_vxlan_scripts
execute_vxlan_scripts
