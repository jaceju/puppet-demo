#!/usr/bin/env bash
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppet-agent
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
echo -e "\n\n[main]\ncertname = puppet-agent.example.com\nserver = puppet-server.example.com\nenvironment = production" \
    | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
sudo systemctl start puppet
sudo systemctl enable puppet