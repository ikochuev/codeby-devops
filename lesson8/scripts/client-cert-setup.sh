#!/bin/bash
DOMAIN="codeby.local"

echo "Ожидание сертификата..."
for i in {1..30}; do
  if [ -f "/tmp/$DOMAIN.crt" ]; then
    cp /tmp/$DOMAIN.crt /usr/local/share/ca-certificates/$DOMAIN.crt
    update-ca-certificates
    echo "✓ Сертификат $DOMAIN доверенный"

    sleep 5
    curl -I https://$DOMAIN && echo "✓ HTTPS работает"
    break
  fi
  sleep 10
done

