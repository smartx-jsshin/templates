#!/bin/bash

GET_MANUAL_INPUT(){
  echo "Please fill in the below questions correctly"
  echo -e "Wireguard Interface Name (e.g. wg0): "
  read WG_DEV_NAME
  echo -e "Wireguard Interface IP Address (e.g. 192.168.2.1/24): "
  read WG_IP_ADDR
  echo -e "Wiregaurd Peer IP Address (e.g. 192.168.2.2): "
  read WG_PEER_IP
  echo -e "Wireguard Peer Port Number (e.g. 51820): "
  read WG_PEER_PORT
  echo -e "Wireguard Allowed IP Subnets (e.g. 192.168.2.0/24): "
  read WG_ALLOWED_IP
  echo -e "Wireguard Peer Public Key: "
  read WG_PEER_PUBKEY
}

CHECK_EMPTY_PARAMS(){
  if [ -z $WG_DEV_NAME | -z $WG_IP_ADDR | -z $WG_PEER_IP | -z $WG_PEER_PORT | -z $WG_ALLOWED_IP | -z $WG_PEER_PUBKEY ]; then
    echo "Some parameter(s) is empty!"
    exit 1
  fi
}

INCORRECT_PARAMETER_ERROR(){
  echo "ERROR: You execute it in a wrong way"
  echo "Usage: ./configure_wireguard.sh"
  echo "       ./configure_wireguard.sh <WG_IF_NAME> <WG_IP_ADDR> <WG_PEER_IP> <WG_PEER_PORT> <WG_ALLOWED_IP> <PEER_PUBLIC_KEY>"
}

INSTALL_WIREGUARD(){
  add-apt-repository -y ppa:wireguard/wireguard
  apt-get update
  apt-get install -y wireguard-dkms wireguard-tools
}

GENERATE_KEY(){
  umask 077
  wg genkey > privatekey
  wg pubkey < privatekey > publickey
}

ADD_INTERFACE(){
  ip link add ${WG_DEV_NAME} type wireguard
  ip addr add ${WG_IP_ADDR} dev ${WG_DEV_NAME}
  wg set ${WG_DEV_NAME} private-key ./privatekey
  ip link set ${WG_DEV_NAME} up
}

SET_INTERFACE_PEER(){
  wg set ${WG_DEV_NAME} peer ${PEER_PUBKEY} allowed-ips ${WG_ALLOWED_IP} endpoint "${WG_PEER_IP}:${WG_PEER_PORT}"
}

WG_DEV_NAME=
WG_IP_ADDR=
WG_PEER_IP=
WG_PEER_PORT=
WG_ALLOWED_IP=
WG_PEER_PUBKEY=


if [ $(id -u) -ne 0 ]; then
  echo "This script should be executed with ROOT PRIVILEGE"
  exit 1
fi

if [ "$#" -eq 0]; then
  GET_MANUAL_INPUT()
fi 

CHECK_EMPTY_PARAMS()

if [ -z `dpkg -l | grep wireguard` ]; then
  INSTALL_WIREGUARD()
fi

GENERATE_KEY()
ADD_INTERFACE()
SET_INTERFACE_PEER()
