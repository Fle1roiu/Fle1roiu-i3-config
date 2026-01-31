#!/bin/bash

echo "--- 1. Копирование твоих личных конфигов ---"
# Сначала переносим твои файлы, чтобы они уже были на месте
mkdir -p ~/.config/i3
cp -rf ~/Fle1roiu-i3-config/i3/config* ~/.config/i3/
cp -f ~/Fle1roiu-i3-config/.Xresources ~/

echo "--- 2. Поштучная установка пакетов (pacman) ---"
# Твой список, каждая команда отдельно для контроля
sudo pacman -S --noconfirm alsa-utils
sudo pacman -S --noconfirm base
sudo pacman -S --noconfirm base-devel
sudo pacman -S --noconfirm cava
sudo pacman -S --noconfirm cmatrix
sudo pacman -S --noconfirm dkms
sudo pacman -S --noconfirm dmenu
sudo pacman -S --noconfirm fastfetch
sudo pacman -S --noconfirm feh
sudo pacman -S --noconfirm git
sudo pacman -S --noconfirm gnome-themes-extra
sudo pacman -S --noconfirm grub
sudo pacman -S --noconfirm htop
sudo pacman -S --noconfirm i3-wm
sudo pacman -S --noconfirm i3blocks
sudo pacman -S --noconfirm i3lock
sudo pacman -S --noconfirm i3status
sudo pacman -S --noconfirm iwd
sudo pacman -S --noconfirm kitty
sudo pacman -S --noconfirm less
sudo pacman -S --noconfirm libva-nvidia-driver
sudo pacman -S --noconfirm lightdm
sudo pacman -S --noconfirm lightdm-gtk-greeter
sudo pacman -S --noconfirm linux
sudo pacman -S --noconfirm linux-firmware
sudo pacman -S --noconfirm linux-headers
sudo pacman -S --noconfirm lxappearance
sudo pacman -S --noconfirm mc
sudo pacman -S --noconfirm nano
sudo pacman -S --noconfirm network-manager-applet
sudo pacman -S --noconfirm networkmanager
sudo pacman -S --noconfirm otf-font-awesome
sudo pacman -S --noconfirm picom
sudo pacman -S --noconfirm pipewire-pulse
sudo pacman -S --noconfirm polybar
sudo pacman -S --noconfirm python-pillow
sudo pacman -S --noconfirm python-pip
sudo pacman -S --noconfirm rofi
sudo pacman -S --noconfirm sassc
sudo pacman -S --noconfirm smartmontools
sudo pacman -S --noconfirm stow
sudo pacman -S --noconfirm sudo
sudo pacman -S --noconfirm thunar
sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd
sudo pacman -S --noconfirm vim
sudo pacman -S --noconfirm wget
sudo pacman -S --noconfirm wireless_tools
sudo pacman -S --noconfirm wpa_supplicant
sudo pacman -S --noconfirm xdg-utils
sudo pacman -S --noconfirm xorg-xinit
sudo pacman -S --noconfirm xss-lock
sudo pacman -S --noconfirm xterm
sudo pacman -S --noconfirm zram-generator

echo "--- 3. Установка yay и Bibata ---"
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si --noconfirm
cd ~
yay -S --noconfirm bibata-cursor-theme-bin

echo "--- 4. Установка тем (Papirus и Catppuccin) ---"
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme ~/papirus-icon-theme
cd ~/papirus-icon-theme && chmod +x install.sh && ./install.sh
cd ~

git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme ~/Catppuccin-GTK-Theme
cd ~/Catppuccin-GTK-Theme && chmod +x install.sh && ./install.sh --tweaks macchiato macos outline float -t mauve -l
cd ~

echo "--- 5. Темы Polybar и Rofi (adi1090x) ---"
# Polybar
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh
cd ~
# Запуск конкретного стиля
bash ~/.config/polybar/launch.sh --shapes
cd ~

# Rofi
git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh
cd ~

echo "--- УСТАНОВКА ЗАВЕРШЕНА ---"
