#!/bin/bash

set -e

# 1. Install packages
echo "Installing zsh, tmux, neovim, git, wget, curl, and nerd fonts..."
sudo pacman -Syu --noconfirm zsh tmux neovim git wget curl ttf-hack-nerd xclip

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
fi

# 3. Install Oh My Zsh plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# 4. Install vim-plug for Neovim
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  echo "Installing vim-plug for Neovim..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 5. Clone your dotfiles repo
echo "Cloning your dotfiles repo..."
git clone https://github.com/adriang-90/dotfiles ~/dotfiles-tmp

# 6. Copy config files from the repo to their locations
echo "Copying config files..."
sudo cp ~/dotfiles-tmp/zshrc /root/.zshrc
cp ~/dotfiles-tmp/zshrc ~/.zshrc

sudo mkdir -p /root/.config/nvim
mkdir -p ~/.config/nvim
sudo cp ~/dotfiles-tmp/init.vim /root/.config/nvim/init.vim
cp ~/dotfiles-tmp/init.vim ~/.config/nvim/init.vim

sudo cp ~/dotfiles-tmp/tmux.conf /root/.tmux.conf
cp ~/dotfiles-tmp/tmux.conf ~/.tmux.conf

# 7. Set Zsh as default shell for user
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  echo "Setting Zsh as default shell for user $USER..."
  chsh -s /usr/bin/zsh
fi

# 8. Install Neovim plugins (requires Neovim to be run at least once)
echo "Installing Neovim plugins..."
nvim --headless +PlugInstall +qall

echo "All done! Please restart your terminal or log out and back in for all changes to take effect."
