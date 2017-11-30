#!/bin/bash
vxlan_id="100"
vxlan_iface="vxlan${vxlan_id}"

other_con_ip="<other_con_ip>"
other_con_mac="<other_con_mac>"
other_box_ip="<other_box_ip>"

sudo ip link add dev ${vxlan_iface} type vxlan id ${vxlan_id} proxy learning l2miss l3miss dstport 4789
net_id=`docker inspect --format {{.ID}} test_net`
sudo ip link set ${vxlan_iface} master br-${net_id:0:12}
ip link set ${vxlan_iface} up
ip neighbor add ${other_con_ip} lladdr ${other_con_mac} dev ${vxlan_iface}
bridge fdb add ${other_con_mac} dev ${vxlan_iface} self dst ${other_box_ip} vni ${vxlan_id} port 4789
