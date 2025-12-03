#!/bin/bash

echo "=== Setting up CLIENT machine ==="

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y openssh-client

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

cp /vagrant/server_key /home/vagrant/.ssh/vagrant_key
chmod 600 /home/vagrant/.ssh/vagrant_key
chown vagrant:vagrant /home/vagrant/.ssh/vagrant_key

cat > /home/vagrant/.ssh/config << 'EOF'
Host server
    HostName 192.168.60.20
    User vagrant
    Port 22
    IdentityFile ~/.ssh/vagrant_key
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF

chmod 600 /home/vagrant/.ssh/config
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "=== CLIENT setup completed ==="
echo "Now you can run: ssh server"

