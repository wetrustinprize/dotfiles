#!/usr/bin/env bash

# gets sudo permission
sudo -v

echo "Installing xmonad packages..."

sudo apt install xmonad libghc-xmonad-contrib-dev xterm dmenu xmobar nitrogen dunst xdotool

echo "Creating symlinks..."

XMONADFILESDIR="$(pwd)/xmonad/"
ln -s "$XMONADFILESDIR/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
ln -s "$XMONADFILESDIR/scripts" "$HOME/.xmonad/scripts"

echo "Finished installing xmonad"