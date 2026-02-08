#!/bin/bash

# Цвета
BLUE='\033[1;34m'
NC='\033[0m'

# 1. Логотип Fle1roiu (F и 1 выделены)
clear
echo -e "${BLUE}"
echo "  ______ _        ______ __             _        "
echo " |  ____| |      |  ____/_ |           (_)       "
echo " | |__  | |      | |__   | | _ __  ___ _ _   _  "
echo " |  __| | |      |  __|  | || '__|/ _ \| | | | |"
echo " | |    | |____  | |____ | || |  | (_) | | |_| | "
echo " |_|    |______| |______||_||_|   \___/|_|\___/ "
echo "                                                "
echo -e "${NC}"

echo "================================================="
echo "      FLE1ROIU SYSTEM INSTALLATION MENU"
echo "================================================="
echo ""

# 2. Меню выбора
echo -e "Выберите ваш дистрибутив / Select your OS:"
echo "1) Arch Linux"
echo "2) Fedora"
echo "3) Ubuntu"
echo "4) Exit / Выход"
echo ""
read -p ">>> Введите цифру [1-4]: " choice

# 3. Логика запуска
case $choice in
    1)
        if [ -f "archlinux.sh" ]; then
            echo -e "\n[!] Запуск скрипта для Arch Linux..."
            chmod +x archlinux.sh
            ./archlinux.sh
        else
            echo -e "\n[ERROR] Файл archlinux.sh не найден!"
            sleep 2
            ./install.sh
        fi
        ;;
    2)
        echo -e "\n[?] Скрипт для Fedora в разработке..."
        sleep 2
        ./install.sh
        ;;
    3)
        echo -e "\n[?] Запуск скрипта для Ubuntu..."
        chmod +x ubuntu.sh
        ./ubuntu.sh
        ;;
    4)
        echo "Выход..."
        exit 0
        ;;
    *)
        echo "Ошибка: Неверный ввод."
        sleep 1
        ./install.sh
        ;;
esac
