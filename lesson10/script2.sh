#!/bin/bash

folder="$HOME/myfolder"

if [ ! -d "$folder" ]; then
    echo "Папка $folder не найдена. Сначала запустите script1.sh"
    exit 1
fi

echo "Обработка файлов в $folder"

# Количество файлов
file_count=$(ls "$folder" | wc -l)
echo "Найдено файлов: $file_count"

# Права для file2
if [ -f "$folder/file2.txt" ]; then
    perms=$(stat -c "%a" "$folder/file2.txt" 2>/dev/null || echo "000")
    if [ "$perms" = "777" ]; then
        chmod 664 "$folder/file2.txt"
        echo "Права file2.txt изменены: 777 -> 664"
    fi
fi

# Удаление пустых файлов
empty_deleted=0
for file in "$folder"/*.txt; do
    if [ -f "$file" ] && [ ! -s "$file" ]; then
        rm "$file"
        empty_deleted=$((empty_deleted + 1))
    fi
done
echo "Удалено пустых файлов: $empty_deleted"

# Оставляем первую строку
for file in "$folder"/*.txt; do
    if [ -f "$file" ] && [ -s "$file" ]; then
        lines=$(wc -l < "$file")
        if [ "$lines" -gt 1 ]; then
            head -n 1 "$file" > "$folder/.tmpfile" && mv "$folder/.tmpfile" "$file"
            echo "В $(basename "$file") оставлена 1 строка (было $lines)"
        fi
    fi
done

# Финальный результат
echo "Результат:"
if [ -d "$folder" ]; then
    remaining=$(ls "$folder" 2>/dev/null | wc -l)
    echo "Осталось файлов: $remaining"
    if [ "$remaining" -gt 0 ]; then
        echo "Содержимое:"
        ls -l "$folder/"
    fi
fi
