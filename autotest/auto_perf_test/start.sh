#!/bin/bash

create_testbed(){
    is_swarm=$1
    cluster_numbers=$2
    control_numbers=$3
    client_numbers=$4

    if [ -f Vagrantfile ]; then
        vagrant destroy -f
    fi

    cp Vagrantfile.org Vagrantfile
    sed -i -e "s/<IS_SWARM>/${is_swarm}/g" -e "s/<CLUSTER_NUMBERS>/${cluster_numbers}/g" \
    -e "s/<CONTROL_NUMBERS>/${control_numbers}/g" -e "s/<CLIENT_NUMBERS>/${client_numbers}/g" Vagrantfile
    vagrant up
}

configure_test(){
    # Copy configuration script from "scripts" directory
    # The script create Docker Network and Containers
    cp scripts/$i/* ./
    #bash configure.sh
}

ping_test(){
    cp scripts/$i/ping.sh ./ping.sh
    #bash ping.sh
    #rm ping.sh
}

iperf_test(){
    cp scripts/$i/iperf.sh ./iperf.sh
    #bash iperf.sh
    #rm iperf.sh
}

remove_testbed(){
    vagrant halt
    vagrant --force destroy
}

summary_test(){
  rm -rf ./results/*
}

TEST_LIST=`grep -o '^[^#]*' test_list.cfg`

for i in ${TEST_LIST}; do
  case $i in
    1) # 1 Box, 2 Containers, Bridge networks
      create_testbed 0 1 1 0
      configure_test $i
      ping_test $i
      iperf_test $i
#      remove_testbed
    ;;
    2) # 2 Boxes, 2 Containers, Through Internet (L3 Networking)
      create_testbed 0 1 2 0
      configure_test $i
      ping_test $i
      iperf_test $i
#      remove_testbed
    ;;
    3) # 2 Boxes, 2 Containers, Manually configured Overlay networking
      create_testbed 0 1 2 0
      configure_test $i
      ping_test $i
      iperf_test $i
      #remove_testbed
    ;;
    4) # 1 Swarm, 2 Boxes, 2 Containers, Overlay Networking
      create_testbed 1 1 1 1
      configure_test $i
      ping_test $i
      iperf_test $i
      remove_testbed
    ;;
    5) # 2 Swarms, 2 Boxes, 2 Containers, Through Internet (L3 Networking)
      create_testbed 1 2 1 0
      configure_test $i
      ping_test $i
      iperf_test $i
      remove_testbed
    ;;
    6) # 2 Swarms, 2 Boxes, 2 Containers, Weave Overlay Networking Driver
      create_testbed 1 2 1 0
      configure_test $i
      ping_test $i
      iperf_test $i
      remove_testbed
    ;;
    7) # 2 Swarms, 4 Boxes, 4 Containers, Multi-hop networking with Weave Driver
      create_testbed 1 2 1 1
      configure_test $i
      ping_test $i
      iperf_test $i
      remove_testbed
    ;;
  esac
done

#summary_test
