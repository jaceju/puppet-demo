#!/usr/bin/env bash
# 安裝 puppetserver
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppetserver
# 修改啟動參數，這裡因為 VM 只有 1G ，所以不能改成 1g ，要用 512m
sudo sed -i 's/2g /512m /g' /etc/default/puppetserver
# 防火牆改 port 8140
sudo ufw allow 8140
# 建立 puupet 用的 ca
sudo /opt/puppetlabs/bin/puppetserver ca setup
# 啟動 server
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
