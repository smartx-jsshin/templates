#!/bin/bash

remove_file_if_exists(){
    file=$1
    if [ -f $file ]; then
        rm $file
    fi
}

remove_log_files(){
    rm results/*
}
vagrant destroy -f
remove_file_if_exists "Vagrantfile"
remove_file_if_exists "configure.sh"
remove_file_if_exists "test.cfg"
remove_file_if_exists "ping.sh"
remove_file_if_exists "iperf.sh"
remove_file_if_exists "vxlan_box1.sh"
remove_file_if_exists "vxlan_box2.sh"
