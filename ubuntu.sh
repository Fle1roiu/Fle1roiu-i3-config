#!/bin/bash

# --- 1. Установка пакетов (pacman) ---
echo "Устанавливаю основные пакеты..."
sudo apt update && sudo apt install -y \
picom zsh chafa kitty alsa-utils arandr build-essential \
fastfetch feh gnome-themes-extra iwd less lxappearance mc nano \
network-manager-gnome fonts-font-awesome pipewire-pulse polybar \
python3-pil python3-pip rofi smartmontools sassc stow sudo thunar \
fonts-jetbrains-mono wget xdg-utils xinit xss-lock zram-tools \
libqt6svg6 qtvirtualkeyboard-plugin libqt6multimedia6-ffmpeg

# --- 2. Установка yay и AUR пакетов ---
echo "Устанавливаю yay и Bibata Cursor..."
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~
yay -S bibata-cursor-theme-bin 
yay -S picom-ftlabs-git
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
cp ~/Fle1roiu-i3-config/fastfetch_ubuntu.png ~/Downloads/ 2>/dev/null

# Копируем конфиги
cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/
cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/
cp ~/Fle1roiu-i3-config/fastfetch/config_ubuntu.jsonc ~/.config/fastfetch/config.jsonc
cp ~/Fle1roiu-i3-config/.Xresources ~/

# Настройка Rofi
mkdir -p ~/.config/rofi/launchers/type-4/
cp ~/Fle1roiu-i3-config/launcher.sh ~/.config/rofi/launchers/type-4/
chmod +x ~/.config/rofi/launchers/type-4/launcher.sh



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

# --- 8. Установка ZSH и темы Kali-Like ---
echo "--- Чистая установка ZSH и темы Kali-Like ---"

# Убеждаемся, что старые конфиги не помешают
rm -rf ~/.oh-my-zsh ~/.zshrc

# 1. Ставим Zsh и зависимости
sudo pacman -S --noconfirm zsh wget curl git ttf-fira-code

# 2. Ставим Oh My Zsh в автоматическом режиме
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 3. Качаем тему Kali-Like
wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme

# 4. Создаем ПРАВИЛЬНЫЙ .zshrc
# Используем кавычки вокруг "EOF", чтобы переменные внутри НЕ раскрывались раньше времени
cat << "EOF" > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF

# 5. Делаем Zsh оболочкой по умолчанию
sudo usermod -s /usr/bin/zsh $USER

# Исправляем возможную ошибку с правами на историю
touch ~/.zsh_history

# 5. Делаем Zsh оболочкой по умолчанию (через usermod для надежности)
sudo usermod -s /usr/bin/zsh $USER

echo "-----------------------------------------------"
echo "Установка завершена! Система перезагрузится через 5 секунд."
sleep 5
sudo reboot
