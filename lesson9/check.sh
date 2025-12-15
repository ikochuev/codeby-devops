#!/bin/bash
echo "=== CHECK HOMEWORK ==="

echo "1. Virtual machines status:"
vagrant status

echo -e "\n2. Rsync configuration (from backup script):"
vagrant ssh server -c "
  echo '=== Rsync command used in mysql_backup.sh ==='
  grep 'rsync' /home/vagrant/mysql_backup.sh
"

echo -e "\n3. Show current data in database:"
vagrant ssh server -c "
  echo '=== Before delete ==='
  mysql -uroot -pRootPass123! -e 'USE company_db; SELECT * FROM employees;'
"

echo -e "\n4. Create test backup:"
echo "Running: /home/vagrant/mysql_backup.sh"
vagrant ssh server -c "/home/vagrant/mysql_backup.sh"

echo -e "\n5. Backup files on server:"
vagrant ssh server -c "ls -lh /opt/mysql_backup/ | head -5"

echo -e "\n6. Backup files on store:"
vagrant ssh store -c "ls -lh /opt/store/mysql/"

echo -e "\n7. Delete database and show it's gone:"
vagrant ssh server -c "
  echo '=== Deleting database ==='
  mysql -uroot -pRootPass123! -e 'DROP DATABASE company_db;'
  echo '=== After delete ==='
  mysql -uroot -pRootPass123! -e 'SHOW DATABASES LIKE \"company_db\";'
"

echo -e "\n8. Restore from latest backup:"
vagrant ssh server -c "
  echo '=== Restoring ==='
  LAST_BACKUP=\$(ls -t /opt/mysql_backup/*.sql.gz | head -1)
  echo 'Using backup file: '\$LAST_BACKUP
  gunzip -c \$LAST_BACKUP | mysql -uroot -pRootPass123!
  echo 'Restore completed'
"

echo -e "\n9. Show restored data:"
vagrant ssh server -c "
  echo '=== After restore ==='
  mysql -uroot -pRootPass123! -e 'SHOW DATABASES LIKE \"company_db\";'
  mysql -uroot -pRootPass123! -e 'USE company_db; SELECT * FROM employees;'
"

echo -e "\n10. Cron jobs on server:"
vagrant ssh server -c "crontab -l"

echo -e "\n=== CHECK COMPLETE ==="
