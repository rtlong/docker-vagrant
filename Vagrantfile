Vagrant.configure('2') do |vagrant|
  vagrant.vm.define 'goodguide-docker' do |config|
    ip_address = ENV.fetch('DOCKER_VAGRANT_IP', '192.168.33.42')

    config.vm.box = "phusion/ubuntu-14.04-amd64"

    config.vm.network "private_network", ip: ip_address

    # Mount your home directory in the VM at the same path, so absolute paths to
    # directories you want to add as mounted volumes are resolvable both inside
    # and outside the container.
    config.vm.synced_folder ENV['HOME'], ENV['HOME']

    # Disable the default /vagrant share, as it's not really applicable
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.provider "virtualbox" do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.memory = 2048
      vb.cpus = 4
    end

    config.vm.provision :docker

    config.vm.provision :shell, privileged: true, inline: <<-SHELL
      echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375"' > /etc/default/docker
      service docker restart
    SHELL

    config.vm.post_up_message = <<-MSG.split("\n").map{|l| "  #{l.strip}" }.join("\n")
      With the docker client installed on your host machine, you can now use
      Docker as you'd expect, by simply telling it where to find the docker daemon:

      $ export DOCKER_HOST='tcp://#{ip_address}:2375'
      $ docker ps
    MSG
  end
end
