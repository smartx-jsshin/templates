#!/bin/bash
sed -i "s/<box1_name>/nettest-control1-1/g" ./test.cfg
sed -i "s/<box2_name>/nettest-control1-1/g" ./test.cfg
sed -i "s/<container1_name>/test_con1/g" ./test.cfg
sed -i "s/<container2_name>/test_con2/g" ./test.cfg
sed -i "s/<container1_ip>/192.168.10.101/g" ./test.cfg
sed -i "s/<container2_ip>/192.168.10.102/g" ./test.cfg
sed -i "s/<container1_subnet>/192.168.10.0\/24/g" ./test.cfg
sed -i "s/<container2_subnet>/192.168.10.0\/24/g" ./test.cfg


source ./test.cfg
vagrant ssh "${box1_name}" -c "docker network create --subnet ${container1_subnet} -d overlay test_net"
if [ "${box1_name}" -ne "${box2_name}" ];then
vagrant ssh "${box2_name}" -c "docker network create --subnet ${container2_subnet} -d overlay test_net"
fi

vagrant ssh "${box1_name}" -c "docker container run -tid --network test_net --ip ${container1_ip} --name ${container1_name} jsshin1230/test_image"
vagrant ssh "${box2_name}" -c "docker container run -tid --network test_net --ip ${container2_ip} --name ${container2_name} jsshin1230/test_image"
