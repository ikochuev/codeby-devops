#!/bin/bash

echo "=== Установка Apache и Nginx ==="

# Обновляем систему
sudo apt update
sudo apt upgrade -y

# Устанавливаем Apache и Nginx
sudo apt install apache2 nginx -y

echo "=== Удаление конфигураций по умолчанию ==="

# Останавливаем сервисы
sudo systemctl stop apache2
sudo systemctl stop nginx

# Удаляем дефолтные конфиги
sudo rm -f /etc/apache2/sites-enabled/000-default.conf
sudo rm -f /etc/nginx/sites-enabled/default

echo "=== Создание папок для контента ==="

# Создаем папки для сайтов
sudo mkdir -p /opt/nginx/www
sudo mkdir -p /opt/apache/www

# Создаем test.html для Apache
sudo tee /opt/apache/www/test.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Apache Test Page</title>
    <meta charset="utf-8">
</head>
<body>
    <h1>✅ Apache работает на порту 8084!</h1>
    <p>Домашнее задание lesson7 выполнено успешно.</p>
    <p>Время: <span id="datetime"></span></p>
    <script>
        document.getElementById('datetime').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF

# Создаем test.html для Nginx
sudo tee /opt/nginx/www/test.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Nginx Test Page</title>
    <meta charset="utf-8">
</head>
<body>
    <h1>✅ Nginx работает на порту 8085!</h1>
    <p>Домашнее задание lesson7 выполнено успешно.</p>
    <p>Время: <span id="datetime"></span></p>
    <script>
        document.getElementById('datetime').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF

# Настраиваем права
sudo chown -R www-data:www-data /opt/nginx/www
sudo chown -R www-data:www-data /opt/apache/www
sudo chmod -R 755 /opt/nginx/www
sudo chmod -R 755 /opt/apache/www

echo "=== Настройка Apache на порт 8084 ==="

# Создаем конфиг для Apache
sudo tee /etc/apache2/sites-available/apache-site.conf << 'EOF'
<VirtualHost *:8084>
    ServerAdmin webmaster@localhost
    DocumentRoot /opt/apache/www
    
    ErrorLog ${APACHE_LOG_DIR}/apache-site-error.log
    CustomLog ${APACHE_LOG_DIR}/apache-site-access.log combined
    
    <Directory /opt/apache/www>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Меняем порт Apache
sudo sed -i 's/Listen 80/Listen 8084/g' /etc/apache2/ports.conf

# Активируем сайт
sudo a2ensite apache-site.conf

echo "=== Настройка Nginx на порт 8085 ==="

# Создаем конфиг для Nginx
sudo tee /etc/nginx/sites-available/nginx-site.conf << 'EOF'
server {
    listen 8085;
    server_name _;
    
    root /opt/nginx/www;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    error_log /var/log/nginx/nginx-site-error.log;
    access_log /var/log/nginx/nginx-site-access.log;
}
EOF

# Активируем сайт Nginx
sudo ln -sf /etc/nginx/sites-available/nginx-site.conf /etc/nginx/sites-enabled/

echo "=== Настройка автозапуска ==="

# Включаем автозапуск
sudo systemctl enable apache2
sudo systemctl enable nginx

echo "=== Запуск серверов ==="

# Перезагружаем конфиги и запускаем
sudo systemctl restart apache2
sudo systemctl restart nginx

echo "=== Проверка работы ==="

# Проверяем статусы
sudo systemctl status apache2 --no-pager
sudo systemctl status nginx --no-pager

# Проверяем открытые порты
sudo ss -tulpn | grep -E '(8084|8085)'

echo "=== Установка завершена! ==="
echo "Apache доступен: http://localhost:8084"
echo "Nginx доступен: http://localhost:8085"
