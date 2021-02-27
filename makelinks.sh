#!/bin/bash

# ZSH Installation
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed, skipping"
else
    echo "Installing Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# SNAP Install
snap install --classic code

# Install dotfiles
rm -i -rf "$HOME/.zshrc"
ln -s $HOME/.dotfiles/mydotfiles/zshrc $HOME/.zshrc

rm -i -rf "$HOME/.p10k.zsh"
ln -s $HOME/.dotfiles/mydotfiles/p10k.zsh $HOME/.p10k.zsh