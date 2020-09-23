#!/usr/bin/env bash
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppetserver
# 不能用 1g ，要用 512m
sudo sed -i 's/2g /512m /g' /etc/default/puppetserver
sudo ufw allow 8140
sudo /opt/puppetlabs/bin/puppetserver ca setup
sudo systemctl start puppetserver
sudo systemctl enable puppetserver
