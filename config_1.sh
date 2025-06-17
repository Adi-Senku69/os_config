#! /bin/bash

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
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 50

# Set Kitty as the default (auto-selects it if no prompt interaction is desired)
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

echo "Kitty has been set as the default terminal emulator."


# Zsh install
echo "Installing zsh"
sudo apt install zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

# continue setting up
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS=(
  "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git autoswitch_virtualenv"
)

echo "Cloning plugins..."
for repo in "${PLUGINS[@]}"; do
  url=${repo%% *}
  name=${repo#* }
  dir="$ZSH_CUSTOM/plugins/$name"
  if [ -d "$dir" ]; then
    echo " - $name already exists, pulling latest..."
    git -C "$dir" pull --ff-only
  else
    echo " - Installing $name..."
    git clone --depth 1 "$url" "$dir"
  fi
done
cp -f .zshrc ~/.zshrc

# Miniconda install
if [ ! -d "~/miniconda3/" ]; then
echo "Installing miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mv Miniconda3-latest-Linux-x86_64.sh ~
bash ~/Miniconda3-latest-Linux-x86_64.sh
rm ~/Miniconda3-latest-Linux-x86_64.sh
fi

# Neovim install
echo "Installing neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
mkdir -p ~/.config/nvim
git clone https://github.com/Adi-Senku69/nvim.git ~/.config/nvim --depth 1
rm nvim-linux-x86_64.tar.gz

echo "Done installing and configuring everything"

exit

