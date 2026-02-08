#!/bin/bash

# --- 1. Обновление и установка базы (APT) ---
echo "Installing base packages for Ubuntu..."
sudo apt update && sudo apt install -y \
picom zsh chafa kitty alsa-utils arandr build-essential \
fastfetch feh gnome-themes-extra iwd less lxappearance mc nano \
network-manager-gnome fonts-font-awesome pipewire-pulse polybar \
python3-pil python3-pip rofi smartmontools sassc stow sudo thunar \
fonts-jetbrains-mono wget xdg-utils xinit xss-lock zram-tools \
libqt6svg6 qtvirtualkeyboard-plugin libqt6multimedia6-ffmpeg unzip

# --- 2. Установка Bibata Cursor и Betterlockscreen (Manual) ---
echo "Installing Themes and Lockscreen..."

# Bibata Cursor (через репозиторий или скачивание)
wget https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.gz
mkdir -p ~/.icons
tar -xvf Bibata-Modern-Classic.tar.gz -d ~/.icons/
rm Bibata-Modern-Classic.tar.gz

# Betterlockscreen (Официальный метод для Debian/Ubuntu)
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip
cd betterlockscreen-main
sudo cp betterlockscreen /usr/local/bin/
sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
cd ..
rm -rf main.zip betterlockscreen-main

# --- 3. Установка внешних тем ---
echo "Installing Rofi and Polybar themes..."
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh
cd ~

git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh
cd ~

# --- 4. Перенос конфигов ---
echo "Copying configs..."
mkdir -p ~/Downloads ~/.config/i3 ~/.config/picom ~/.config/fastfetch ~/.config/kitty

cp ~/Fle1roiu-i3-config/Downloads/linux.jpg ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/Downloads/linux.png ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/
cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/

# --- 5. Автологин и Автозапуск (Safe Mode) ---
echo "Configuring Autologin..."
sudo systemctl disable gdm3 || true # Отключаем стандартный вход Ubuntu

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf

# Создаем .bash_profile БЕЗ РЕКУРСИИ
cat <<EOF > "$HOME/.bash_profile"
if [[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]]; then
  exec startx
fi
EOF

# Создаем .xinitrc
cat <<EOF > "$HOME/.xinitrc"
xrdb -merge ~/.Xresources
exec i3
EOF

# --- 6. Установка ZSH (Kali-Like) ---
echo "Installing ZSH with Kali-theme..."
sudo apt install -y zsh

# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Kali Theme
wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme

# Config ZSH
cat << "EOF" > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF

# Меняем оболочку на ZSH (путь в Ubuntu: /usr/bin/zsh)
sudo usermod -s /usr/bin/zsh $USER

# --- 7. Финал (Wal и Lockscreen) ---
echo "Finalizing colors..."
pip3 install pywal --break-system-packages
wal -i ~/Downloads/linux.png -b 000000
betterlockscreen -u ~/Downloads/linux.png

echo "Done! Rebooting in 5 seconds..."
sleep 5
sudo reboot
