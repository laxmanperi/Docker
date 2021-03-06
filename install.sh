#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible
sudo yum -y install git
sudo yum -y install unzip
sudo yum -y install vim
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker centos
sudo systemctl enable docker 
sudo systemctl start docker 