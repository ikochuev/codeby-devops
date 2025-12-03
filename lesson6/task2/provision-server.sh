#!/bin/bash

echo "=== Setting up SERVER machine ==="

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y openssh-server


mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

ssh-keygen -t rsa -b 2048 -f /vagrant/server_key -N "" -q

cat /vagrant/server_key.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/#PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

sudo systemctl restart sshd

echo "=== SERVER setup completed ==="

