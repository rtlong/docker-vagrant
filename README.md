# docker-vagrant

This is a Vagrantfile for running an Ubuntu VM with Docker installed, exposing the Docker HTTP API over TCP port `2375` to the Host-only Network, which allows you to use Docker on your non-Linux workstation.

Unlike [**boot2docker**][boot2docker], this is a full-fledged Ubuntu VM, rather than being based on TinyCore Linux. As such, VirtualBox Guest Additions are installed, so shared folders and other features work as expected.

If supports Docker volume mounts from your host (OSX) filesystem into the Docker container. To facilitate this support, it shares your entire `$HOME` into the VM at the exact same path. This ensures the absolute host path you must specify to `docker run -v #{host_path}:#{container_path}` is resolved to the same place in the VM as it exists in your home directory. This is also convienient because in most every case, your user directory is the only shared folder you'll need to set up. This makes for less hassle, which is the whole point of this workflow.

[boot2docker]: http://boot2docker.io/

## Installation

Clone the repo somewhere for safe keeping (`~/.local/opt/docker-vagrant` might make a good spot) and then install the file `bin/docker-vagrant` to your `$PATH` somewhere **using a symlink**.

```shell
prefix=$HOME/.local
mkdir -p $prefix/opt $prefix/bin
echo $PATH | grep -o $prefix/bin
# if that returned nothing, add $prefix/bin to your PATH in your shell config (or choose a different prefix directory)
git clone 'https://github.com/rtlong/docker-vagrant.git' $prefix/opt/docker-vagrant
ln -s $prefix/opt/docker-vagrant/bin/docker-vagrant $prefix/bin/docker-vagrant
```

## Usage

Now, without ever having to `cd` to the clone directory, you can work with this VM using the command `docker-vagrant`:

```shell
docker-vagrant up
```

> Note: the shared folder is configured to use NFS, which should be supported on OSX just fine, but I haven't tested on Linux or Windows. Vagrant's going to use `sudo` while bringing the VM up, in order to alter your system's NFS exports file. Please see the Vagrant NFS documentation for more info about this as well as how to avoid typing your password upon each `docker-vagrant up`.

After Vagrant brings up the new VM, it will print some intructions which you'll need to follow:

- Required:
    - Set the `DOCKER_HOST` environment variable; feel free to put this in your shell RC file for ease, or just export it when needed.
- Optional, but highly recommended one-time step:
    - Define a `docker.dev` host in `/etc/hosts` pointing to the host-only-networking IP address of the VM
        - Many GoodGuide docs/configfiles depend on this hostname.

## Known Issues

Vagrant tends to automatically Pause VMs when you sleep your Mac, so if you see timeouts while attempting to talk to Docker, simply try a `docker-vagrant up` to resume the VM.

## Configuration

To alter the IP address or RAM/CPU allocation, copy `config.rb.example` to `config.rb` and change settings accordingly.

## Requirements

- [VirtualBox][]
    - Although, there is nothing in the Vagrantfile that is VirtualBox-specific, and the [base image][] supports VMWare Fusion, so that may also work, but it's not tested.

- [Vagrant][]
    - OSX: You can install via [Homebrew Cask][brew-cask]:

        ```shell
        brew cask install vagrant
        ```

- Docker client
    - OSX: I recommend using Homebrew to install just the docker client.

        ```shell
        brew install docker
        ```

        _([The offical Docker installation instructions for OSX][docker-osx] tell you to use the **boot2docker** installer. The `docker` client this installs will work perfectly fine, though be aware that this package installs the `docker` CLI client _as well as_ the **boot2docker** VM and `boot2docker` management CLI tool. As mentioned in the description, this project is distinct from **boot2docker** and doesn't require it. It doesn't necessarily hurt to have **boot2docker** installed, although be aware that there may be conflicting assumptions made by this project and **boot2docker** -- one that comes to mind is that it uses TLS by having you set the `DOCKER_TLS_VERIFY` variable in your shell, which will cause issues for this project.)_

    - Other OS: [see the official Docker instructions][docker-not-osx]

[base image]: https://vagrantcloud.com/phusion/ubuntu-14.04-amd64
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
[docker-not-osx]: https://docs.docker.com/installation/
[docker-osx]: https://docs.docker.com/installation/mac/
[Vagrant]: http://www.vagrantup.com/downloads.html
[brew-cask]: http://caskroom.io/


## Contributing

Contributions, thoughts, and criticisms are welcome.
