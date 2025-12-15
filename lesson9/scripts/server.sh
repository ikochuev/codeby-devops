#!/bin/bash
echo "Server setup..."

# Установка
apt-get update
apt-get install -y mysql-server rsync sshpass

# MySQL
systemctl start mysql
systemctl enable mysql

mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'RootPass123!';
CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
CREATE TABLE employees (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(100));
INSERT INTO employees (name) VALUES ('Иван Петров'), ('Мария Сидорова');
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'BackupPass123!';
GRANT SELECT, PROCESS, LOCK TABLES ON *.* TO 'backup_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Папка бэкапов
mkdir -p /opt/mysql_backup
chown -R vagrant:vagrant /opt/mysql_backup

# Скрипт бэкапа
cat > /home/vagrant/mysql_backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/mysql_backup"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${DATE}.sql"

echo "Creating backup: backup_${DATE}.sql"

# Бэкап
mysqldump --user=backup_user --password=BackupPass123! --all-databases > $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Backup successful, compressing..."
    gzip $BACKUP_FILE
    echo "Syncing to store..."
    # Синхронизация
    sshpass -p 'vagrant' rsync -avz -e "ssh -o StrictHostKeyChecking=no" \
            ${BACKUP_DIR}/ vagrant@store:/opt/store/mysql/
    echo "Backup completed: backup_${DATE}.sql.gz"
else
    echo "Backup failed!"
fi
EOF

chmod +x /home/vagrant/mysql_backup.sh

# Cron для пользователя vagrant
sudo -u vagrant crontab -l > /tmp/vagrantcron 2>/dev/null || true
echo "0 * * * * /home/vagrant/mysql_backup.sh" >> /tmp/vagrantcron
echo "*/10 * * * * /home/vagrant/mysql_backup.sh" >> /tmp/vagrantcron
sudo -u vagrant crontab /tmp/vagrantcron
rm /tmp/vagrantcron

# Hosts
echo "192.168.56.30 store" >> /etc/hosts

echo "Server done"
