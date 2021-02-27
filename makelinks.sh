#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# ZSH Installation
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed, skipping"
else
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install dotfiles
rm -i -rf "$HOME/.zshrc"
ln -s $HOME/.dotfiles/mydotfiles/zshrc $HOME/.zshrc

rm -i -rf "$HOME/.p10k.zsh"
ln -s $HOME/.dotfiles/mydotfiles/p10k.zsh $HOME/.p10k.zsh

# SNAP and APT Install
source $HOME/.dotfiles/scripts/snap.sh
source $HOME/.dotfiles/scripts/apt.sh
source $HOME/.dotfiles/scripts/nodejs.sh