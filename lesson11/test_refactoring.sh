#!/bin/bash
echo "=== Простой тест скриптов ==="

echo "1. Очистка и запуск script1.sh..."
rm -rf ~/myfolder
./script1.sh
echo ""

echo "2. Запуск script2.sh..."
./script2.sh
echo ""

echo "3. Итоговое состояние:"
if [ -d ~/myfolder ]; then
    echo "Папка: ~/myfolder"
    ls -la ~/myfolder/
    
    echo -e "\nСодержимое файлов:"
    for f in ~/myfolder/*.txt; do
        [ -f "$f" ] || continue
        echo "$(basename "$f"):"
        cat "$f"
        echo "---"
    done
fi

echo -e "\n4. Проверка ShellCheck:"
if shellcheck script1.sh script2.sh; then
    echo "V Оба скрипта прошли проверку ShellCheck"
else
    echo "X Есть предупреждения ShellCheck"
fi
