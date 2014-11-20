require 'pathname'

configfile = Pathname.new(File.expand_path('../config.rb', __FILE__))
if configfile.exist?
  load configfile.path
end

$vm_cpu ||= 4
$vm_ram ||= 3048
$vm_ip ||= '192.168.33.42'

Vagrant.configure('2') do |vagrant|
  vagrant.vm.define 'goodguide-docker' do |config|
    config.vm.box = "docker-vagrant"

    config.vm.network "private_network", ip: $vm_ip

    # Mount your home directory in the VM at the same path, so absolute paths to
    # directories you want to add as mounted volumes are resolvable both inside
    # and outside the container.
    config.vm.synced_folder ENV['HOME'], ENV['HOME'], type: 'nfs'

    # Disable the default /vagrant share, as it's not really applicable
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.provider "virtualbox" do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.memory = $vm_ram
      vb.cpus = $vm_cpu
    end

    config.vm.provision :docker
    config.vm.provision :shell, privileged: true, inline: <<-SHELL
      echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"' > /etc/default/docker
      service docker restart
    SHELL

    config.vm.post_up_message = <<-MSG.split("\n").map{|l| "  #{l[6..-1]}" }.join("\n")
      With the docker client installed on your host machine, you can now use Docker as
      you'd expect, by simply telling it where to find the docker daemon:

        $ export DOCKER_HOST='tcp://#{$vm_ip}:2375'
        $ docker ps

      Additionally, many GG tools/docs expect you to add an entry to /etc/hosts for
      this VM. Add this line to your /etc/hosts file:

        #{$vm_ip} docker.dev
    MSG
  end
end
