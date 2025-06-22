#!/usr/bin/env bash
# continue setting up
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom/themes/powerlevel10k/}"  ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS=(
  "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git autoswitch_virtualenv"
  "https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git zsh-syntax-highlighting"
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
if [[ ! -d "$HOME/miniconda3/" ]]; then
  echo "Installing miniconda"
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  mv Miniconda3-latest-Linux-x86_64.sh ~
  bash ~/Miniconda3-latest-Linux-x86_64.sh -b
  rm ~/Miniconda3-latest-Linux-x86_64.sh
fi 

# Neovim install
if [[ ! -d "$HOME/.config/nvim/" ]]; then
  echo "Installing neovim"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  mkdir -p ~/.config/nvim
  git clone https://github.com/Adi-Senku69/nvim.git ~/.config/nvim --depth 1
  rm nvim-linux-x86_64.tar.gz
fi

# Installing yazi
if ! command -v yazi &>/dev/null; then
  cargo install --locked yazi-fm yazi-cli &>/dev/null &
fi

# Setting the aliases for zsh
cp -f aliases.zsh ~/.oh-my-zsh/custom/

sudo apt autoremove -y

echo "Done installing and configuring everything"

exit
