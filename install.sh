#!/bin/bash

set -x -e

if [[ -z $prefix ]]; then
  prefix=$HOME/.local
fi

mkdir -p $prefix/opt $prefix/bin

dest=$prefix/opt/docker-vagrant
if [ ! -d $dest ]; then
  git clone 'https://github.com/GoodGuide/docker-vagrant.git' $dest
else
  (
    cd $dest
    git fetch
    git merge --ff-only origin/master
  )
fi

if [ -e $prefix/bin/docker-vagrant ]; then
  echo "Symlink already exists. Not overwriting"
else
  ln -vs $dest/bin/docker-vagrant $prefix/bin/docker-vagrant
fi

if ! (echo $PATH | grep -q $prefix/bin); then
  echo "Be sure to add '$prefix/bin' to your PATH."
fi
