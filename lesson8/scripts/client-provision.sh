#!/bin/bash
apt-get update
apt-get install -y sshpass curl

echo "192.168.56.10 codeby.local www.codeby.local" >> /etc/hosts
echo "✓ codeby.local добавлен в /etc/hosts"

