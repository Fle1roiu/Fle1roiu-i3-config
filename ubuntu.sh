#!/bin/bash

# --- 1. Пакеты (Чисто под Ubuntu) ---
echo "Installing base packages..."
sudo apt update && sudo apt install -y \
picom zsh chafa kitty alsa-utils arandr build-essential \
neofetch feh gnome-themes-extra iwd less lxappearance mc nano \
network-manager-gnome fonts-font-awesome pipewire-pulse polybar \
python3-pil python3-pip rofi smartmontools sassc stow sudo thunar \
fonts-jetbrains-mono wget xdg-utils xinit xss-lock zram-tools \
libqt6svg6 qtvirtualkeyboard-plugin unzip git \
autoconf automake pkg-config libmagickcore-dev libxcb-composite0-dev \
libxcb-xinerama0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev \
libxcb-xrm-dev libxcb-util0-dev libxcb-image0-dev libxcb-cursor-dev \
libxcb-keysyms1-dev libjpeg-dev

# --- 2. i3lock-color (Сборка для работы локскрина) ---
echo "Building i3lock-color..."
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color && autoreconf -fi
mkdir -p build && cd build
../configure --prefix=/usr --sysconfdir=/etc
make && sudo make install
cd ../.. && rm -rf i3lock-color

# --- 3. Темы и Курсор ---
echo "Downloading themes..."
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.gz
mkdir -p ~/.icons && tar -xvf Bibata-Modern-Classic.tar.gz -C ~/.icons/
rm Bibata-Modern-Classic.tar.gz
wget -qO- https://git.io/papirus-icon-theme-install | sh

# --- 4. ПЕРЕНОС ФАЙЛОВ (Твоя схема) ---
echo "Deploying configs and assets..."
mkdir -p ~/Downloads ~/.config/i3 ~/.config/picom ~/.config/kitty
mkdir -p ~/.config/rofi/launchers/type-4/

# Копируем картинки
cp ~/Fle1roiu-i3-config/Downloads/linux.jpg ~/Downloads/ 2>/dev/null
cp ~/Fle1roiu-i3-config/Downloads/linux.png ~/Downloads/ 2>/dev/null
# Твой спец-перенос для neofetch
cp ~/Fle1roiu-i3-config/fastfetch_ubuntu.png ~/Downloads/neofetch.png 2>/dev/null

# Конфиги
cp ~/Fle1roiu-i3-config/i3/config ~/.config/i3/config
cp ~/Fle1roiu-i3-config/picom.conf ~/.config/picom/
cp ~/Fle1roiu-i3-config/kitty.conf ~/.config/kitty/
cp ~/Fle1roiu-i3-config/.Xresources ~/

# Лаунчер Rofi
cp ~/Fle1roiu-i3-config/launcher.sh ~/.config/rofi/launchers/type-4/
chmod +x ~/.config/rofi/launchers/type-4/launcher.sh

# --- 5. Внешние установщики ---
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git ~/polybar-themes
cd ~/polybar-themes && chmod +x setup.sh && ./setup.sh && cd ~
git clone --depth=1 https://github.com/adi1090x/rofi.git ~/rofi-themes
cd ~/rofi-themes && chmod +x setup.sh && ./setup.sh && cd ~

# --- 6. ZSH ---
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
wget -O ~/.oh-my-zsh/themes/kali-like.zsh-theme https://raw.githubusercontent.com/clamy54/kali-like-zsh-theme/master/kali-like.zsh-theme
cat << "EOF" > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="kali-like"
plugins=(git)
source $ZSH/oh-my-zsh.sh
EOF
sudo usermod -s /usr/bin/zsh $USER

# --- 7. Финал ---
pip3 install pywal --break-system-packages
wal -i ~/Downloads/linux.png -b 000000

echo "Done! Fastfetch config skipped as requested."
