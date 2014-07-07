# vagrantfile-docker

This is a Vagrantfile for running an Ubuntu VM with Docker installed, exposing the Docker HTTP API over TCP port `2375` to the Host-only Network.

## Usage

```shell
% vagrant up
% export DOCKER_HOST='tcp://192.168.33.42:2375'
% docker info
```
## Description

Unlike [**boot2docker**][boot2docker], this is a full-fledged Ubuntu VM rather than being based on TinyCore Linux. As such, VirtualBox Guest Additions are installed, so shared folders work as expected.

It shares your entire `$HOME` into the VM at the exact same path, in order to ensure the the absolute host path you must specify to `docker run -v #{host_path}:#{container_path}` is resolved to the same place in the VM as it exists in your home directory. This is also convienient because in most every case, this is the only shared folder you'll need to set up, which means less hassle, which is the whole point of this workflow.

[boot2docker]: http://boot2docker.io/

## Requirements

- [Vagrant][]

- Docker client
    - [OSX][docker-osx]: these offical Docker installation instructions for OSX have you using the **boot2docker** installer. This will work perfectly fine, though be aware that this packages installs the `docker` CLI client _as well as_ the **boot2docker** VM and `boot2docker` management CLI tool. As mentioned in the description, this project is distinct from **boot2docker** and doesn't require it. It doesn't hurt to have **boot2docker** installed. It's quite small and light, which makes it nice to have available for simple things.

        If you don't want the full **boot2docker** package, you can also just:

        ```shell
        % brew install docker
        ```

    - [Other OS][docker-not-osx]

- [VirtualBox][] &mdash; There is nothing in the Vagrantfile that is VirtualBox-specific, and the [base image][] supports VMWare Fusion, so that may also work, but it's not tested.

[base image]: https://vagrantcloud.com/phusion/ubuntu-14.04-amd64
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
[docker-not-osx]: https://docs.docker.com/installation/
[docker-osx]: https://docs.docker.com/installation/mac/
[Vagrant]: http://www.vagrantup.com/downloads.html

## Installation

1. Clone this repo somewhere.

2. Install the `docker-vagrant` command, by symlinking `bin/docker-vagrant` into your `$PATH`.

    Inside the clone directory (assuming your `PATH` includes `~/bin`):

    ```shell
    ln -s $PWD/bin/docker-vagrant ~/bin/
    ```

3. From anywhere, run `docker-vagrant up`. See the next section for more about this command.

4. Follow the instructions at the end of the `up` output regarding `export`ing the `DOCKER_HOST` env variable.

5. Use docker normally, keeping in mind that ports are forwarded not to the host but to the VM, so point things at `192.168.33.42`

## The `docker-vagrant` command

There is a small wrapper script at `bin/docker-vagrant`. It could be run directly, but it's meant to be symlinked into your `PATH` somewhere. (Note that copying the script to your `PATH` will _not_ work.) It uses the symlink to determine the directory in which the original lives, and uses that as the Vagrant environment directory. This achieves the goal of having it available everywhere, with none of the downsides of the other approaches (see the _"Other approaches"_ section). It's only downside is the need for a separate command to control it, but since it simply wraps calls to `vagrant` it has the same interface that you're used to.

## Other approaches to using this Vagrantfile:

I really wanted for this to feel like **boot2docker** in how it is controllable from everwhere and is more-or-less a singleton on the host system. This use-case, it turns out, is quite contrary to Vagrant's own, so I explored these other options before landing on the wrapper script as the best way to make this happen.

1. Use normally. `cd` into this folder, `vagrant up`. This is fine, but requires the extra step of changing to this directory to interact with the VM.

2. Symlink this Vagrantfile up a directory, into the place where you clone all your projects. This is nice because you can interact with the VM from each of projects.

     _Except_, when the project has it's own Vagrantfile. Then the symlinked, shared VM is no longer accessible without changing to a directory under the projects dir without a Vagrantfile. This happens because Vagrant looks in your current working dir and then checks parent dirs until it finds a Vagrant file; in the case where the project is missing one, it uses the Vagrantfile in the parent dir; in the case where it has a Vagrantfile of its own, it stops looking after finding that one, so the shared Vagrantfile is ignored.

3. Load this Vagrantfile globally. Something like this:

    ```ruby
    # ~/.vagrant.d/Vagrantfile
    load File.expand_path('~/path/to/this/repo/Vagrantfile')
    ```

    You also, then, need to have a fallback (empty) Vagrantfile in some common place (`~/Vagrantfile` works, or somewhere like the #2 example), so Vagrant always considers you within a "Vagrant environment."

    This approach is the closest to feeling like the VM is defined globally. As it works even when you define a Vagrantfile in a project. The VM is always accessible.

    The downside is that and VM defined in a Vagrantfile anywhere needs to use the explicit `vm.define` multi-machine approach (despite needing only one machine). Otherwise, the definition in the Vagrantfile will be considered defaults for all the explicitly-defined VMs (which includes the one in this Vagrantfile) and thus you won't see it create an additional VM.

## Contributing

Contributions, thoughts, and criticisms are welcome.
