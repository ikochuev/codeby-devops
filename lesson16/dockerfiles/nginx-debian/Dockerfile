# Используем базовый образ Debian 11
FROM debian:11

# Устанавливаем Nginx и очищаем кэш для уменьшения размера образа
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/www

# Копируем конфигурацию Nginx и статический контент
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /opt/www/

# Открываем порт 80
EXPOSE 80

# Устанавливаем ENTRYPOINT для запуска Nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
