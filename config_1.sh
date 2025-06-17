#! /bin/bash
if grep -qi "kali" /etc/os-release; then
  sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg
fi

if grep -qi "mint" /etc/os-release; then
  mint=0
fi

sudo apt update 


# Prerequisites
echo "Installing Prerequisites"
sudo apt install git nodejs npm xclip ripgrep -y

# Install Jetbrains Mono Font
echo "Installing necessary fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
unzip JetBrainsMono.zip -d ~/.local/share/fonts
rm JetBrainsMono.zip
fc-cache -f -v

# Kitty install
echo "Installing kitty"
sudo apt install kitty -y
rm -rf ~/.config/kitty
mkdir -p ~/.config/kitty
git clone https://github.com/Adi-Senku69/kitty_config.git ~/.config/kitty
mkdir -p ~/.local/share/applications/
cp kitty.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/kitty.desktop
# Set Kitty as an alternative terminal
if [ ! $mint -eq 0 ]; then
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50
# Set Kitty as the default (auto-selects it if no prompt interaction is desired)
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
else
  gsettings set org.cinnamon.desktop.default-applications.terminal exec '$(which kitty)'

fi
echo "Kitty has been set as the default terminal emulator."


# Zsh install
echo "Installing zsh"
sudo apt install zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

