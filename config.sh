#! /bin/bash

sudo apt update && sudo apt upgrade -y

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
git clone https://github.com/Adi-Senku69/kitty_config.git ~/.config
mkdir -p ~/.local/share/applications/
mv  ./kitty.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/kitty.desktop

# Zsh install
echo "Installing zsh"
sudo apt install zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS=(
  "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git autoswitch_virtualenv"
  "https://github.com/gael-ian/zsh-history-substring-search.git history-substring-search"
  "https://github.com/zsh-users/zsh-autosuggestions.git zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting"
  "https://github.com/supercrabtree/you-should-use.git you-should-use"
  "https://github.com/juling/reafd-z.git z"  # 'z' cd-history plugin
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
echo "Installing miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
mv Miniconda3-latest-Linux-x86_64.sh ~
bash ~/Miniconda3-latest-Linux-x86_64.sh
rm ~/Miniconda3-latest-Linux-x86_64.sh

# Neovim install
echo "Installing neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
git clone https://github.com/Adi-Senku69/nvim.git ~/.config --depth 1

echo "Done configuring everything"
