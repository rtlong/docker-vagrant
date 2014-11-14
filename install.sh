#!/bin/bash

if [[ -z $prefix ]]; then
  prefix=$HOME/.local
fi

mkdir -p $prefix/opt $prefix/bin

git clone 'https://github.com/GoodGuide/docker-vagrant.git' $prefix/opt/docker-vagrant
ln -s $prefix/opt/docker-vagrant/bin/docker-vagrant $prefix/bin/docker-vagrant

if ! (echo $PATH | grep -q $prefix/bin); then
  echo "Be sure to add '$prefix/bin' to your PATH."
fi
