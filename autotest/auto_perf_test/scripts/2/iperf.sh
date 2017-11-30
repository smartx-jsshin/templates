#!/bin/bash
source ./test.cfg

execute_iperf_server(){
# Execute Iperf server as a daemon in both containers
echo "Execute iperf server in container ${container1_name} in box ${box1_name}"
vagrant ssh "${box1_name}" -c "docker exec ${container1_name} nohup iperf -s -D &>/dev/null" -- -f
echo "Execute iperf server in container ${container2_name} in box ${box2_name}"
vagrant ssh "${box2_name}" -c "docker exec ${container2_name} nohup iperf -s -D &>/dev/null" -- -f
}

execute_iperf_client(){
# Execute Iperf client to the server working in different container
echo "Execute iperf client in container ${container1_name} for sending packets to ${container2_name}"
vagrant ssh "${box1_name}" -c "docker exec ${container1_name} iperf -t 3 -c ${container2_ip} > iperf_${container1_name}.log"
echo "Execute iperf client in container ${container2_name} for sending packets to ${container1_name}"
vagrant ssh "${box2_name}" -c "docker exec ${container2_name} iperf -t 3 -c ${container1_ip} > iperf_${container2_name}.log"
}

download_iperf_logs(){
if [ -d "./results/1" ]; then
    mkdir -p "./results/1"
fi

cur_time=$(date +%Y%m%d_%H%M%S)
vagrant ssh "${box1_name}" -c "cat iperf_${container1_name}.log > /vagrant/results/1/${cur_time}_iperf.log"
vagrant ssh "${box2_name}" -c "cat iperf_${container2_name}.log >> /vagrant/results/1/${cur_time}_iperf.log"

if [[ ! -s ./results/1/${cur_time}_iperf.log ]]; then
    echo "Iperf Test was unsuccessful!" > ./result/1/${cur_time}_iperf.log
fi
}

execute_iperf_server
execute_iperf_client
download_iperf_logs
