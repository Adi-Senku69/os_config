#! /bin/bash

sudo apt update 

# Prerequisites
echo "Installing Prerequisites"
sudo apt install git nodejs npm xclip -y

# Install Jetbrains Mono Font
echo "Installing necessary fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts
rm JetBrainsMono.zip
fc-cache -f -v

# Kitty install
echo "Installing kitty"
sudo apt install kitty
rm -rf ~/.config/kitty
mkdir -p ~/.config/kitty
git clone https://github.com/Adi-Senku69/kitty_config.git ~/.config/kitty
mkdir -p ~/.local/share/applications/
cp kitty.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/kitty.desktop

# Zsh install
echo "Installing zsh"
sudo apt install zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
