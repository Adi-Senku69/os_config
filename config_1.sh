#!/usr/bin/env bash
if grep -qi "kali" /etc/os-release; then
    sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg
    sudo apt update
    mint=1
fi

if grep -qi "mint" /etc/os-release; then
  mint=0
fi

if ! command -v nala &>/dev/null; then
  sudo apt install nala -y
fi

# Installing rust
if ! command -v rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Installing rustup if not present
if ! command -v rustup &>/dev/null; then
  sudo nala install rustup -y
fi

sudo nala update

# Prerequisites
echo "Installing Prerequisites"
sudo nala install git nodejs npm xclip ripgrep fd-find fzf jq 7zip nala zoxide -y

# Install Jetbrains Mono Font
if [[ ! -d "$HOME/.local/share/fonts" ]] &&  ! ls "$HOME/.local/share/fonts/" | grep -i "jetbrains.*nerd" &>/dev/null; then
  echo "Installing necessary fonts"
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
  mkdir -p ~/.local/share/fonts
  unzip JetBrainsMono.zip -d ~/.local/share/fonts
  rm JetBrainsMono.zip
  fc-cache -f -v
fi

# Kitty install
if ! command -v kitty &>/dev/null; then
  echo "Installing kitty"
  sudo nala install kitty -y
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
fi


# Zsh install
if ! command -v zsh &>/dev/null; then
  echo "Installing zsh"
  sudo nala install zsh
fi
# Installing oh-my-zsh
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh}" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi
