#!/bin/bash

# Copy config files to current directory
cp ~/.zshrc .
cp ~/.config/nvim/init.vim .
cp ~/.tmux.conf .

# Add files to git
git add zshrc init.vim tmux.conf

# Commit with a message (you can change the message)
git commit -m "Backup: zsh, nvim, and tmux config files"

# Push to origin main
git push origin main
