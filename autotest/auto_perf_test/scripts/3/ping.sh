#!/bin/bash
source ./test.cfg

vagrant ssh "${box1_name}" -c "docker exec ${container1_name} /bin/ping -q -U -W 3 -c 5 ${container2_ip} > ping-${container1_name}.log"
vagrant ssh "${box2_name}" -c "docker exec ${container2_name} /bin/ping -q -U -W 3 -c 5 ${container1_ip} > ping-${container2_name}.log"

if [ ! -d "./results/1" ]; then 
    mkdir -p "./results/1"
fi

cur_time=$(date +%F_%T)
vagrant ssh "${box1_name}" -c "cat ping-${container1_name}.log > /vagrant/results/1/${cur_time}_ping.log"
vagrant ssh "${box2_name}" -c "cat ping-${container2_name}.log >> /vagrant/results/1/${cur_time}_ping.log"

if [[ ! -s ./results/1/${cur_time}_ping.log ]]; then
    echo "Ping Test was unsuccessful!" > ./results/1/${cur_time}_ping.log
fi

