#!/bin/bash
install_weave_plugin(){
sudo docker plugin install weaveworks/net-plugin:latest_release
}

customize_weave(){
docker plugin disable weaveworks/net-plugin:latest_release
docker plugin set weaveworks/net-plugin:latest_release PARAM=VALUE
docker plugin enable weaveworks/net-plugin:latest_release
}

download_weave(){
sudo curl -L git.io/weave -o /usr/local/bin/weave
sudo chmod a+x /usr/local/bin/weave
}

install_weave_plugin
# customize_weave
download_weave
