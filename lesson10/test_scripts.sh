#!/bin/bash
echo "Тестирование"

echo "1. Первый запуск script1"
./script1.sh
echo ""

echo "2. Первый запуск script2"
./script2.sh
echo ""

echo "3. Второй запуск script2"
./script2.sh
echo ""

echo "4. Второй запуск script1"
./script1.sh
echo ""

echo "5. Третий запуск script2"
./script2.sh
echo ""

echo "Финальное состояние"
ls -la ~/myfolder/ 2>/dev/null || echo "Папка не существует"
