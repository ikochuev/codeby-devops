# Используем легковесный базовый образ Alpine[citation:3]
FROM alpine:latest

# Устанавливаем Nginx и создаем необходимые директории
RUN apk add --no-cache nginx && \
    mkdir -p /opt/www /var/log/nginx /var/lib/nginx && \
    chown -R nginx:nginx /var/log/nginx /var/lib/nginx

# Копируем конфигурацию Nginx
COPY default.conf /etc/nginx/http.d/default.conf

# Копируем статический контент
COPY index.html /opt/www/

# Открываем порт 80 для HTTP-трафика
EXPOSE 80

# Запускаем Nginx в foreground режиме[citation:3]
CMD ["nginx", "-g", "daemon off;"]
