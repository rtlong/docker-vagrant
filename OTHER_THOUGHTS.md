# Other thoughts

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
