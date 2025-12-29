# Этап 1: Сборка (Builder)
# Используем полный образ Node для сборки
FROM node:18 AS builder
WORKDIR /app
# 1. СОЗДАЕМ ПУСТУЮ ДИРЕКТОРИЮ /app/build
RUN mkdir -p /app/build
# 2. Теперь можно создать в ней файл
RUN echo '<!DOCTYPE html><html><body><h1>App Built with Multi-stage!</h1></body></html>' > /app/build/index.html

# Этап 2: Финальный образ для запуска
# Используем легковесный Nginx на Alpine для запуска
FROM nginx:alpine
# Копируем собранные артефакты из этапа builder
COPY --from=builder /app/build/index.html /usr/share/nginx/html/
# Копируем наш кастомный конфиг Nginx (если он есть)
# COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
# Команда запуска уже определена в базовом образе nginx:alpine
