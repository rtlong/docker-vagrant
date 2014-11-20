#!/bin/bash -eux

if [ ! -e /usr/lib/apt/methods/https ]; then
  apt-get update
  apt-get install -y apt-transport-https
fi

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

echo 'deb https://get.docker.com/ubuntu docker main' > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y lxc-docker

# Allow access on TCP port
echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"' > /etc/default/docker
