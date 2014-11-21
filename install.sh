#!/bin/bash

set -e

fancy_echo() {
  printf "\n%b\n" "$1"
}

e() {
  fancy_echo "$*" >&2
  $@
}

if [[ -z $prefix ]]; then
  prefix=$HOME/.local
fi

e mkdir -p $prefix/opt $prefix/bin

dest=$prefix/opt/docker-vagrant
if [ ! -d "$dest" ]; then
  e git clone 'https://github.com/rtlong/docker-vagrant.git' "$dest"
else
  (
    cd $dest
    e git fetch
    e git merge --ff-only origin/master
  )
fi

if [ -e $prefix/bin/docker-vagrant ]; then
  echo "Symlink already exists. Not overwriting"
else
  e ln -vs $dest/bin/docker-vagrant $prefix/bin/docker-vagrant
fi

if ! (echo $PATH | grep -q $prefix/bin); then
  echo "Be sure to add '$prefix/bin' to your PATH."
fi
