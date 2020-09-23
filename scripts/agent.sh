#!/usr/bin/env bash
# 安裝 puppet-agent
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppet-agent
# 設定 agent 的 CA 和 server
echo -e "\n\n[main]\ncertname = puppet-agent.example.com\nserver = puppet-server.example.com\nenvironment = production" \
    | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
# 啟動 agent
sudo systemctl start puppet
sudo systemctl enable puppet