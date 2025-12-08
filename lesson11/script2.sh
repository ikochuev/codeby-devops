#!/bin/bash
# script2.sh - обработка файлов в папке myfolder
# Рефакторинг для lesson11

# Константы
readonly TARGET_FOLDER="$HOME/myfolder"  # Папка для обработки
readonly TEMP_FILE="${TARGET_FOLDER}/.tmp"  # Временный файл

# Функция подсчета файлов (исправлено SC2012)
count_files() {
    local folder="$1"
    local count=0
    
    # Используем find вместо ls для обработки специальных символов
    if [ -d "$folder" ]; then
        count=$(find "$folder" -maxdepth 1 -type f -name "*.txt" 2>/dev/null | wc -l)
    fi
    
    echo "$count"
    return 0
}

# Функция исправления прав файла
fix_permissions() {
    local file="$1"
    local current_perms
    
    # Получаем текущие права
    current_perms=$(stat -c "%a" "$file" 2>/dev/null || echo "000")
    
    # Меняем если 777
    if [ "$current_perms" = "777" ]; then
        if chmod 664 "$file" 2>/dev/null; then
            echo "Права файла $(basename "$file") изменены: 777 -> 664"
            return 0
        else
            echo "Ошибка при изменении прав файла $(basename "$file")" >&2
            return 1
        fi
    fi
    
    return 0
}

# Функция удаления пустых файлов (исправлено SC2030, SC2031)
remove_empty_files() {
    local folder="$1"
    local empty_count=0
    local file
    
    # Используем временный файл для хранения списка
    local temp_list="${TARGET_FOLDER}/.file_list"
    
    # Находим все txt файлы и сохраняем в список
    find "$folder" -maxdepth 1 -name "*.txt" -type f > "$temp_list" 2>/dev/null
    
    # Обрабатываем файлы из списка
    while IFS= read -r file; do
        if [ -f "$file" ] && [ ! -s "$file" ]; then  # Файл пустой
            if rm "$file" 2>/dev/null; then
                echo "Удален пустой файл: $(basename "$file")"
                empty_count=$((empty_count + 1))
            fi
        fi
    done < "$temp_list"
    
    # Удаляем временный список
    rm -f "$temp_list" 2>/dev/null
    
    echo "Всего удалено пустых файлов: $empty_count"
    return 0
}

# Функция обрезки файлов до одной строки
trim_to_first_line() {
    local folder="$1"
    local file
    local temp_list="${TARGET_FOLDER}/.txt_files"
    
    # Создаем список файлов для обработки
    find "$folder" -maxdepth 1 -name "*.txt" -type f > "$temp_list" 2>/dev/null
    
    while IFS= read -r file; do
        # Проверяем что это файл и не ссылка на временный файл
        if [ -f "$file" ] && [ -s "$file" ] && [ "$(basename "$file")" != ".tmp" ]; then
            local line_count
            line_count=$(wc -l < "$file" 2>/dev/null || echo 0)
            
            if [ "$line_count" -gt 1 ]; then
                # Сохраняем первую строку во временный файл
                if head -n 1 "$file" > "$TEMP_FILE" 2>/dev/null && \
                   mv "$TEMP_FILE" "$file" 2>/dev/null; then
                    echo "В файле $(basename "$file") оставлена 1 строка (было $line_count)"
                fi
            fi
        fi
    done < "$temp_list"
    
    # Удаляем временные файлы
    rm -f "$temp_list" "$TEMP_FILE" 2>/dev/null
    
    return 0
}

# Основная функция
main() {
    echo "Обработка файлов в $TARGET_FOLDER..."
    
    # Проверяем существование папки
    if [ ! -d "$TARGET_FOLDER" ]; then
        echo "Ошибка: папка $TARGET_FOLDER не найдена" >&2
        echo "Сначала запустите script1.sh" >&2
        return 1
    fi
    
    # Шаг 1: Подсчет файлов
    local file_count
    file_count=$(count_files "$TARGET_FOLDER")
    echo "Найдено файлов: $file_count"
    
    # Шаг 2: Исправление прав file2.txt
    if [ -f "${TARGET_FOLDER}/file2.txt" ]; then
        fix_permissions "${TARGET_FOLDER}/file2.txt"
    fi
    
    # Шаг 3: Удаление пустых файлов
    remove_empty_files "$TARGET_FOLDER"
    
    # Шаг 4: Обрезка до первой строки
    trim_to_first_line "$TARGET_FOLDER"
    
    # Шаг 5: Финальный результат
    echo "Результат обработки:"
    local remaining_count
    remaining_count=$(count_files "$TARGET_FOLDER")
    echo "Осталось файлов: $remaining_count"
    
    if [ "$remaining_count" -gt 0 ]; then
        echo "Содержимое папки:"
        ls -l "$TARGET_FOLDER/" 2>/dev/null || echo "Не удалось отобразить содержимое"
    fi
    
    return 0
}

# Запуск основной функции
main "$@"
exit $?
