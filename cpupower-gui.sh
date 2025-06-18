#!/bin/bash

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "Для выполнения скрипта требуются права root. Запустите с sudo!"
    exit 1
fi

# Проверка установки dialog
if ! command -v dialog &> /dev/null; then
    echo "Установите 'dialog' для работы скрипта: sudo apt install dialog"
    exit 1
fi

# Создание временного файла
tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/menu$$

# Гарантия удаления временного файла при выходе
trap "rm -f $tempfile" 0 1 2 5 15

# Функция выполнения команд
execute_command() {
    clear
    echo "Выполняется: $1"
    if eval "$1"; then
        echo -e "\nУспешно выполнено!"
        read -p "Нажмите Enter для продолжения..."
    else
        echo -e "\nОшибка выполнения!"
        read -p "Нажмите Enter для возврата..."
    fi
}

# Главное меню
while true; do
    dialog --clear --title "Управление частотами CPU" \
        --keep-tite --menu "Выберите действие:" 15 50 5 \
        1 "Высокая производительность ( 5.14GHz )" \
        2 "Cредняя производительность (  2.8GHz )" \
        3 "Низкая производительность  (  1.8GHz )" \
        4 "Режим энергосбережения     (    1GHz )" \
        5 "Режим пишущей машинки      (  600MHz )" \
        6 "Выход" 2> $tempfile

    choice=$(cat $tempfile)

    case $choice in
        1)
            execute_command "sudo cpupower frequency-set -d 400MHz -u 5.14GHz"
            execute_command "cpupower frequency-info"
            ;;
        2)
            execute_command "sudo cpupower frequency-set -d 400MHz -u 2.8GHz"
            execute_command "cpupower frequency-info"
            ;;
        3)
            execute_command "sudo cpupower frequency-set -d 400MHz -u 1.8GHz"
            execute_command "cpupower frequency-info"
            ;;
        4)
            execute_command "sudo cpupower frequency-set -d 400MHz -u 1GHz"
            execute_command "cpupower frequency-info"
            ;;
        5)
            execute_command "sudo cpupower frequency-set -d 400MHz -u 600MHz"
            execute_command "cpupower frequency-info"
            ;;
        6)
            clear
            echo "Завершение работы"
            exit 0
            ;;
        *)
            echo "Некорректный выбор"
            exit 1
            ;;
    esac
done