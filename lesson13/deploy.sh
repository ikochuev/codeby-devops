#!/bin/bash

echo "==========================================="
echo "  Ansible Roles: MySQL & Apache Deployment "
echo "==========================================="

BASE_DIR="$(pwd)"
echo "Working directory: $BASE_DIR"

# Очистка
echo "🧹 Очистка..."
vagrant destroy -f 2>/dev/null || true
rm -rf .vagrant/ 2>/dev/null || true

# Запуск ВМ
echo "🚀 Запуск виртуальных машин..."
vagrant up

echo "⏳ Ожидание запуска ВМ (30 секунд)..."
sleep 30

# Получаем SSH конфиг
echo "🔍 Получение SSH конфигурации..."
vagrant ssh-config > "$BASE_DIR/ssh_config.txt"

# Парсим порты и ключи
UBUNTU_PORT=$(grep -A 5 "Host ubuntu" "$BASE_DIR/ssh_config.txt" | grep Port | awk '{print $2}')
CENTOS_PORT=$(grep -A 5 "Host centos" "$BASE_DIR/ssh_config.txt" | grep Port | awk '{print $2}')
UBUNTU_KEY=$(grep -A 5 "Host ubuntu" "$BASE_DIR/ssh_config.txt" | grep IdentityFile | head -1 | awk '{print $2}')
CENTOS_KEY=$(grep -A 5 "Host centos" "$BASE_DIR/ssh_config.txt" | grep IdentityFile | head -1 | awk '{print $2}')

echo "Ubuntu: порт $UBUNTU_PORT, ключ $UBUNTU_KEY"
echo "CentOS: порт $CENTOS_PORT, ключ $CENTOS_KEY"

# Создаем inventory с абсолютными путями
echo "📋 Создание inventory..."
INVENTORY_FILE="$BASE_DIR/inventory.ini"
cat > "$INVENTORY_FILE" << INVEOF
[all]
ubuntu ansible_host=127.0.0.1 ansible_port=$UBUNTU_PORT ansible_user=vagrant ansible_ssh_private_key_file=$UBUNTU_KEY
centos ansible_host=127.0.0.1 ansible_port=$CENTOS_PORT ansible_user=vagrant ansible_ssh_private_key_file=$CENTOS_KEY

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
INVEOF

echo "Inventory создан: $INVENTORY_FILE"

# Запуск Ansible с явным путем к inventory
echo "🎯 Запуск Ansible..."
cd "$BASE_DIR/playbooks"
echo "Running: ansible-playbook -i '$INVENTORY_FILE' playbook.yml"
ansible-playbook -i "$INVENTORY_FILE" playbook.yml

echo "✅ Проверка установки..."
sleep 10

echo ""
echo "==========================================="
echo "          Результаты установки             "
echo "==========================================="
echo ""
echo "Проверка MySQL на Ubuntu:"
vagrant ssh ubuntu -c "sudo systemctl status mysql 2>/dev/null" && echo "✅ MySQL работает" || echo "❌ MySQL не работает"

echo ""
echo "Проверка MySQL на CentOS:"
vagrant ssh centos -c "sudo systemctl status mariadb 2>/dev/null" && echo "✅ MariaDB работает" || echo "❌ MariaDB не работает"

echo ""
echo "Проверка Apache на Ubuntu:"
vagrant ssh ubuntu -c "sudo systemctl status apache2 2>/dev/null" && echo "✅ Apache работает" || echo "❌ Apache не работает"

echo ""
echo "Проверка Apache на CentOS:"
vagrant ssh centos -c "sudo systemctl status httpd 2>/dev/null" && echo "✅ Apache работает" || echo "❌ Apache не работает"

echo ""
echo "==========================================="
echo "Установка завершена!"
echo "==========================================="
