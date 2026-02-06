#!/bin/bash

echo "--- 1. Установка пакетов (pacman) ---"
sudo pacman -S --noconfirm --needed zsh chafa kitty alsa-utils arandr base base-devel cava cmatrix fastfetch feh gnome-themes-extra iwd less lxappearance mc nano network-manager-applet otf-font-awesome pipewire-pulse polybar python-pillow python-pip rofi smartmontools sassc stow sudo thunar ttf-jetbrains-mono-nerd wget xdg-utils xorg-xinit xss-lock zram-generator qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg autotiling
echo "--- 2. Установка yay и AUR пакетов ---"
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~
yay -S --noconfirm bibata-cursor-theme-bin

echo "--- 3. Установка внешних тем (Papirus, Polybar, Rofi) ---"
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme ~/papirus-icon-theme
cd ~/papirus-icon-theme && chmod +x install.sh && ./install.sh
cd ~

git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh
bash ~/.config/polybar/launch.sh --shapes
cd ~

git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh
cd ~

echo "--- 4. Перенос файлов и конфигов (Финал) ---"
# Создаем папки
mkdir -p ~/Downloads
mkdir -p ~/.config/i3
mkdir -p ~/.config/picom

# Копируем обои
cp ~/Fle1roiu-i3-config/Downloads/linux.jpg ~/Downloads/
cp ~/Fle1roiu-i3-config/Downloads/linux.png ~/Downloads/

# Копируем конфиги
cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/.Xresources ~/
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/

cd ~
# --- Настройка Rofi (Type 4) ---
mkdir -p ~/.config/rofi/launchers/type-4/

# Копируем файл
cp ~/Fle1roiu-i3-config/launcher.sh ~/.config/rofi/launchers/type-4/

# Даем права
chmod +x ~/.config/rofi/launchers/type-4/launcher.sh

# Переходим и запускаем (используем &, чтобы скрипт не завис!)
cd ~/.config/rofi/launchers/type-4/ && ./launcher.sh &

yay -S picom-ftlabs-git --noconfirm


yay -S plymouth

echo "--- Установка и настройка темы Plymouth: i_use_arch_btw ---"

echo "--- Настройка параметров GRUB для Plymouth ---"

# Путь к конфигу
GRUB_CONF="/etc/default/grub"

# Проверяем, есть ли уже quiet и splash, если нет - добавляем
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CONF"; then
    # Добавляем quiet, если его нет
    if ! grep -q "quiet" <<< $(grep "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CONF"); then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="quiet /' "$GRUB_CONF"
    fi
    # Добавляем splash, если его нет
    if ! grep -q "splash" <<< $(grep "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CONF"); then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="splash /' "$GRUB_CONF"
    fi
fi

# Обновляем конфиг GRUB, чтобы изменения вступили в силу
if [ -d /boot/grub ]; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo "GRUB обновлен успешно!"
else
    echo "Ошибка: Директория /boot/grub не найдена. Проверь свой загрузчик."
fi

# 1. Клонируем репозиторий во временную папку
git clone https://github.com/nenad/arch-beat

# 2. Копируем папку с темой в системную директорию
sudo cp -r ~/arch-beat /usr/share/plymouth/themes/

# 3. Устанавливаем тему как дефолтную
sudo plymouth-set-default-theme -R arch-beat

# 4. Добавляем 'plymouth' в список HOOKS в конфиге mkinitcpio (если его там еще нет)
# Важно: он должен идти СРАЗУ после 'udev'
sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev plymouth/' /etc/mkinitcpio.conf

# 5. Пересобираем образы initramfs
sudo mkinitcpio -P

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Тема загрузки успешно установлена!"

#!/bin/bash

echo "--- Начинаем установку 'Джентльменского набора' i3 ---"

# 1. Установка пакетов через yay
# Убираем старье (feh, i3lock, sddm, neofetch)
# Ставим базу: i3lock-color, betterlockscreen, fastfetch, bc, imagemagick
echo "Устанавливаю софт..."
yay -S --needed --noconfirm i3lock-color betterlockscreen-git bc xorg-xprop xorg-xrandr

# 2. Удаление SDDM и других мешающих менеджеров
echo "Настраиваю чистый запуск без пароля..."
sudo systemctl disable sddm gdm lightdm || true
sudo pacman -Rs sddm --noconfirm || true

# 3. Настройка Автологина (TTY1) для ЛЮБОГО пользователя
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf

# 4. Настройка автозапуска i3 после логина
# Создаем и правим .bash_profile
if [ ! -f "$HOME/.bash_profile" ]; then touch "$HOME/.bash_profile"; fi
if ! grep -q "exec startx" "$HOME/.bash_profile"; then
    echo -e '\nif [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then\n  exec startx\nfi' >> "$HOME/.bash_profile"
fi

# Создаем .xinitrc, чтобы startx знал, что запускать i3
echo "exec i3" > "$HOME/.xinitrc"

# 5. Первичная настройка Betterlockscreen (кеширование обоев)
# Предполагаем, что твои обои лежат по этому пути:

betterlockscreen -u ~/Downloads/linux.png --blur 1

xrdb -merge ~/.Xresources  # Вот эта строка подтягивает цвета
exec i3

mkdir ~/.config/kitty/

cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/

echo "-----------------------------------------------"
echo "Установка завершена! Перезагружаюсь через 5 секунд..."
sleep 5

cp ~/Fle1roiu-i3-config/fastfetch.png ~/Downloads

cp ~/Fle1roiu-i3-config/config.jsonc ~/.config/fastfetch/

sudo reboot

