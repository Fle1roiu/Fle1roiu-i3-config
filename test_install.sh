#!/bin/bash

# --- 1. Установка пакетов (pacman) ---
echo "Устанавливаю основные пакеты..."
sudo pacman -S --noconfirm --needed btop picom zsh chafa kitty alsa-utils arandr base base-devel cava cmatrix fastfetch feh gnome-themes-extra iwd less lxappearance mc nano network-manager-applet otf-font-awesome pipewire-pulse polybar python-pillow python-pip rofi smartmontools sassc stow sudo thunar ttf-jetbrains-mono-nerd wget xdg-utils xorg-xinit xss-lock zram-generator qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg autotiling python-pywal

# --- 2. Установка yay и AUR пакетов ---
echo "Устанавливаю yay и Bibata Cursor..."
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~
yay -S bibata-cursor-theme-bin 
yay -S picom-ftlabs-git
yay -S plymouth 
yay -S betterlockscreen 
yay -S i3lock-color

# --- 3. Установка внешних тем ---
echo "Устанавливаю темы и иконки..."
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme ~/papirus-icon-theme
cd ~/papirus-icon-theme && chmod +x install.sh && ./install.sh
cd ~

git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh
cd ~

git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh
cd ~

# --- 4. Перенос файлов и конфигов ---
echo "Копирую конфиги и ресурсы..."
mkdir -p ~/Downloads ~/.config/i3 ~/.config/picom ~/.config/fastfetch ~/.config/kitty

# Копируем обои и картинки
cp ~/Fle1roiu-i3-config/Downloads/linux.jpg ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/Downloads/linux.png ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/fastfetch.png ~/Downloads/ 2>/dev/null

# Копируем конфиги
cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/
cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/
cp ~/Fle1roiu-i3-config/config.jsonc ~/.config/fastfetch/
cp ~/Fle1roiu-i3-config/.Xresources ~/

# Настройка Rofi
mkdir -p ~/.config/rofi/launchers/type-4/
cp ~/Fle1roiu-i3-config/launcher.sh ~/.config/rofi/launchers/type-4/
chmod +x ~/.config/rofi/launchers/type-4/launcher.sh

# --- 5. Настройка Plymouth (Загрузочный экран) ---
echo "Настраиваю Plymouth..."
git clone https://github.com/nenad/arch-beat ~/arch-beat
sudo cp -r ~/arch-beat /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R arch-beat

# Правим конфиг GRUB
GRUB_CONF="/etc/default/grub"
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash /' "$GRUB_CONF"
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Правим mkinitcpio
sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev plymouth/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

# --- 6. Автологин и Автозапуск ---
echo "Настраиваю автологин и старт иксов..."
sudo systemctl disable sddm gdm lightdm || true

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf

# Создаем .bash_profile
echo -e '\nif [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then\n  exec startx\nfi' >> "$HOME/.bash_profile"

# Создаем ПРАВИЛЬНЫЙ .xinitrc (чтобы подгружались цвета)
cat <<EOF > "$HOME/.xinitrc"
xrdb -merge ~/.Xresources
exec i3
EOF

# --- 7. Финальные штрихи (Wal и Lockscreen) ---
echo "Генерирую цвета и кэш экрана блокировки..."
wal -i ~/Downloads/linux.png -b 000000
betterlockscreen -u ~/Downloads/linux.png --blur 1

echo "-----------------------------------------------"
echo "Установка завершена! Система перезагрузится через 5 секунд."
sleep 5
sudo reboot
