#!/bin/bash
echo "Store setup..."

apt-get update
apt-get install -y rsync sshpass

mkdir -p /opt/store/mysql
chown -R vagrant:vagrant /opt/store/mysql

echo "192.168.56.20 server" >> /etc/hosts

# Включаем парольный SSH для простоты
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

echo "Store done"
