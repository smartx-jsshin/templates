#!/bin/bash

enableRemoteOvsdbAccess() {
  ovs-appctl -t ovsdb-server ovsdb-server/add-remote ptcp:6640
}

deleteAllBridges() {
  for bridge in `ovs-vsctl list-br`; do
    ovs-vsctl del-br $bridge
  done
}

if [ `id -u` -ne 0 ]; then
  echo "You have to execute this script with ROOT PRIVILEGE"
  exit 1
fi

OPT=$1
if [ -z $OPT ]; then
  echo "ERROR: You didn't input any Subcommand"
  echo "Usage: ./ovs-util <SubCMD>"
  echo "[ Sub Commands List ]"
  echo "del-brs: Delete All OVS Bridges"
  echo "en-ovsdb: enable remote OVSDB Access"

  exit 1
fi

case $OPT in
  del-brs) deleteAllBridges;;
  en-ovsdb) enableRemoteOvsdbAccess;;
  *) echo "ERROR: Unavailable Subcommand"
     echo "Usage: ./ovs-util <SubCMD>"
     echo "[ Sub Commands List ]"
     echo "del-brs: Delete All OVS Bridges"
     echo "en-ovsdb: enable remote OVSDB Access"
     exit 1;;
esac
