Vagrant.configure("2") do |config|

  # Server
  config.vm.define :server do |server|
    server.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--name", "server", "--memory", "1024"]
    end
    server.vm.box = "ubuntu/bionic64"
    server.vm.host_name = "puppet-server.example.com"
    server.vm.network "private_network", ip: "192.168.0.103"

    server.vm.provision :shell do |s|
      s.path = "./scripts/hosts.sh"
      s.privileged = false
    end

    server.vm.provision :shell do |s|
      s.path = "./scripts/server.sh"
      s.privileged = false
    end
  end

  # Agent
  config.vm.define :agent do |agent|
    agent.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--name", "agent", "--memory", "512"]
    end
    agent.vm.box = "ubuntu/bionic64"
    agent.vm.host_name = "puppet-agent.example.com"
    agent.vm.network "private_network", ip: "192.168.0.104"

    agent.vm.provision :shell do |s|
      s.path = "./scripts/hosts.sh"
      s.privileged = false
    end

    agent.vm.provision :shell do |s|
      s.path = "./scripts/agent.sh"
      s.privileged = false
    end
  end
end
