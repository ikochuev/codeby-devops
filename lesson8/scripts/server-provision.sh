#!/bin/bash
DOMAIN="codeby.local"

apt-get update
apt-get install -y apache2 openssl openssh-server sshpass

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/$DOMAIN.key \
  -out /etc/ssl/certs/$DOMAIN.crt \
  -subj "/CN=$DOMAIN"

echo "Ожидание client (192.168.56.11)..."
for i in {1..20}; do
  if sshpass -p 'vagrant' scp /etc/ssl/certs/$DOMAIN.crt vagrant@192.168.56.11:/tmp/ 2>/dev/null; then
    echo "✓ Сертификат скопирован на client"
    break
  fi
  echo "Попытка $i/20..."
  sleep 10
done

a2enmod ssl rewrite headers

cat > /etc/apache2/sites-available/$DOMAIN.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    RewriteEngine On
    RewriteCond %{HTTPS} off [OR]
    RewriteCond %{HTTP_HOST} ^www\. [NC]
    RewriteRule ^ https://$DOMAIN%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    DocumentRoot /var/www/html
    
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/$DOMAIN.crt
    SSLCertificateKeyFile /etc/ssl/private/$DOMAIN.key
    
    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined
</VirtualHost>
EOF

a2ensite $DOMAIN
a2dissite 000-default.conf
systemctl restart apache2

echo "✓ Apache настроен для $DOMAIN"

