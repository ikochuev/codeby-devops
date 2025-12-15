#!/bin/bash
# script1.sh - создание папки и тестовых файлов
# Рефакторинг для lesson11

# Константы
readonly TARGET_FOLDER="$HOME/myfolder"  # Папка для работы
readonly RANDOM_LENGTH=20                # Длина случайной строки

# Функция для создания файлов
create_files() {
    local folder="$1"
    
    # Приветствие
    echo -e "\033[35mCODEBY \033[34mDEVOPS \033[32mIS \033[33mMY \033[31mEXPERIENCE\033[0m"

    # Файл 1: приветствие и дата
    echo "Текущее время: $(date '+%Y-%m-%d %H:%M:%S')" > "${folder}/file1.txt"
    
    # Файл 2: пустой файл с правами 777
    touch "${folder}/file2.txt"
    chmod 777 "${folder}/file2.txt"
    
    # Файл 3: случайная строка заданной длины
    head -c 100 /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c $RANDOM_LENGTH > "${folder}/file3.txt"
    
    # Файлы 4-5: пустые файлы
    touch "${folder}/file4.txt"
    touch "${folder}/file5.txt"
    
    return 0
}

# Основная функция
main() {
    echo "Создание тестовых файлов..."
    
    # Создаем папку если не существует
    if ! mkdir -p "$TARGET_FOLDER" 2>/dev/null; then
        echo "Ошибка: не удалось создать папку $TARGET_FOLDER" >&2
        return 1
    fi
    
    # Создаем файлы
    if ! create_files "$TARGET_FOLDER"; then
        echo "Ошибка при создании файлов" >&2
        return 1
    fi
    
    # Вывод результата
    echo "Готово! Создано в $TARGET_FOLDER:"
    ls -l "$TARGET_FOLDER/"
    
    return 0
}

# Проверка ShellCheck: SC1090, SC1091, SC2004, SC2086, SC2164
# Все предупреждения исправлены

# Запуск основной функции
main "$@"
exit $?
