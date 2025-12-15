#!/bin/bash

folder="$HOME/myfolder"

echo "Создание папки и файлов..."

mkdir -p "$folder"


# Приветствие
echo -e "\033[35mCODEBY \033[34mDEVOPS \033[32mIS \033[33mMY \033[31mEXPERIENCE\033[0m"

# Файл 1
echo "Текущее время: $(date '+%Y-%m-%d %H:%M:%S')" > "$folder/file1.txt"

# Файл 2
touch "$folder/file2.txt"
chmod 777 "$folder/file2.txt"

# Файл 3 (исправляем зависание - ограничиваем чтение)
head -c 100 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 20 > "$folder/file3.txt"

# Файлы 4-5
touch "$folder/file4.txt"
touch "$folder/file5.txt"

echo "Готово. Создано в $folder:"
ls -l "$folder/"
