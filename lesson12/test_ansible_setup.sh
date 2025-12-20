#!/bin/bash
# Скрипт полной проверки lesson12
# Запуск: ./test_ansible_setup.sh

echo "=========================================="
echo "      ПОЛНАЯ ПРОВЕРКА LESSON 12"
echo "=========================================="

echo -e "\n1. ПРОВЕРКА ВИРТУАЛЬНЫХ МАШИН"
echo "------------------------------------------"
vagrant status
echo ""

echo "2. ПРОВЕРКА SSH КЛЮЧЕЙ VAGRANT"
echo "------------------------------------------"
echo "Dev VM SSH key:"
vagrant ssh-config dev | grep -A1 IdentityFile
echo -e "\nProd VM SSH key:"
vagrant ssh-config prod | grep -A1 IdentityFile
echo ""

echo "3. ПРОВЕРКА PYTHON НА ВМ"
echo "------------------------------------------"
echo "Dev Python version:"
vagrant ssh dev -c "python3 --version"
echo -e "\nProd Python version:"
vagrant ssh prod -c "python3 --version"
echo ""

echo "4. ПРОВЕРКА ANSIBLE INVENTORY"
echo "------------------------------------------"
cd ansible
echo "Dev inventory:"
ansible-inventory -i env/dev/hosts --list --yaml | head -20
echo -e "\nProd inventory:"
ansible-inventory -i env/prod/hosts --list --yaml | head -20
echo ""

echo "5. ПРОВЕРКА ПОДКЛЮЧЕНИЯ ANSIBLE"
echo "------------------------------------------"
echo "Ping to dev:"
ansible -i env/dev/hosts dev -m ping
echo -e "\nPing to prod:"
ansible -i env/prod/hosts prod -m ping
echo ""

echo "6. ЗАПУСК PLAYBOOK"
echo "------------------------------------------"
echo "=== Dev environment ==="
ansible-playbook -i env/dev/hosts playbooks/setup_nginx.yml
echo -e "\n=== Prod environment ==="
ansible-playbook -i env/prod/hosts playbooks/setup_nginx.yml
echo ""

echo "7. ФИНАЛЬНАЯ ПРОВЕРКА УСТАНОВКИ"
echo "------------------------------------------"
echo "Checking installed packages on dev:"
ansible -i env/dev/hosts dev -m shell -a "dpkg -l | grep -E 'wget|htop|nginx'"
echo -e "\nChecking Nginx status on prod:"
ansible -i env/prod/hosts prod -m shell -a "systemctl status nginx | head -5"
echo ""

echo "8. ПРОВЕРКА ВЕБ-СЕРВЕРА"
echo "------------------------------------------"
echo "Dev (http://192.168.56.10):"
curl -s -I http://192.168.56.10 | head -1
echo "Prod (http://192.168.56.20):"
curl -s -I http://192.168.56.20 | head -1
echo ""

echo "=========================================="
echo "        ПРОВЕРКА ЗАВЕРШЕНА ✓"
echo "=========================================="
