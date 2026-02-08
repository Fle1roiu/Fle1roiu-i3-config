#!/bin/bash

# --- 1. Установка пакетов (APT вместо pacman) ---
echo "Installing base packages..."
sudo apt update && sudo apt install -y \
picom zsh chafa kitty alsa-utils arandr build-essential \
fastfetch feh gnome-themes-extra iwd less lxappearance mc nano \
network-manager-gnome fonts-font-awesome pipewire-pulse polybar \
python3-pil python3-pip rofi smartmontools sassc stow sudo thunar \
fonts-jetbrains-mono wget xdg-utils xinit xss-lock zram-tools \
libqt6svg6 qtvirtualkeyboard-plugin libqt6multimedia6-ffmpeg unzip \
imagemagick libmagickcore-dev libxcb-composite0-dev libxcb-xinerama0-dev \
libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-util0-dev \
libxcb-image0-dev libxcb-cursor-dev libxcb-keysyms1-dev

# --- 2. Установка Betterlockscreen и i3lock-color (Ubuntu way) ---
# На Ubuntu нет AUR/yay, поэтому ставим напрямую
echo "Installing Lockscreen components..."
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color && ./install-i3lock-color.sh && cd .. && rm -rf i3lock-color

wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip && cd betterlockscreen-main
sudo cp betterlockscreen /usr/local/bin/
sudo cp system/betterlockscreen@.service /usr/lib/systemd/system/
cd .. && rm -rf main.zip betterlockscreen-main

# --- 3. Темы и иконки (Твои пути) ---
echo "Installing themes..."
# Bibata Cursor
wget https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.gz
mkdir -p ~/.icons
tar -xvf Bibata-Modern-Classic.tar.gz -C ~/.icons/
rm Bibata-Modern-Classic.tar.gz

# Papirus, Polybar, Rofi themes
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme ~/papirus-icon-theme
cd ~/papirus-icon-theme && chmod +x install.sh && ./install.sh && cd ~

git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh && cd ~

git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh && cd ~

# --- 4. Перенос файлов и конфигов (Твоя структура) ---
echo "Copying configs..."
mkdir -p ~/Downloads ~/.config/i3 ~/.config/picom ~/.config/fastfetch ~/.config/kitty

cp ~/Fle1roiu-i3-config/Downloads/linux.jpg ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/Downloads/linux.png ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/fastfetch_ubuntu.png ~/Downloads/ 2>/dev/null

cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/
cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/
cp ~/Fle1roiu-i3-config/fastfetch/config_ubuntu.jsonc ~/.config/fastfetch/config.jsonc
cp ~/Fle1roiu-i3-config/.Xresources ~/

# Твоя настройка Rofi (Type-4)
mkdir -p ~/.config/rofi/launchers/type-4/
cp ~/Fle1roiu-i3-config/launcher.sh ~/.config/rofi/launchers/type-4/
chmod +x ~/.config/rofi/launchers/type-4/launcher.sh

# --- 5. Автологин и Автозапуск ---
echo "Configuring Autologin..."
sudo systemctl disable gdm3 || true

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf

# Безопасный .bash_profile (добавляем только если нет)
if ! grep -q "startx" "$HOME/.bash_profile"; then
  echo -e '\nif [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then\n  exec startx\nfi' >> "$HOME/.bash_profile"
fi

cat <<EOF > "$HOME/.xinitrc"
xrdb -merge ~/.Xresources
exec i3
EOF

# --- 6. Установка ZSH (Kali-Like) ---
echo "Configuring ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme

cat << "EOF" > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF

sudo usermod -s /usr/bin/zsh $USER

# --- 7. Финальные штрихи ---
echo "Finalizing colors..."
pip3 install pywal --break-system-packages
wal -i ~/Downloads/linux.png -b 000000
betterlockscreen -u ~/Downloads/linux.png --blur 1

echo "All done! System will reboot in 5 seconds."
sleep 5
sudo reboot
