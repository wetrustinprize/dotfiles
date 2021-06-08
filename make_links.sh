#!/usr/bin/env bash

sudo -v

DOTFILESDIR="$(pwd)/dotfiles/"
CFGFILESDIR="$(pwd)/configs/"
LOCALBINFILESDIR="$(pwd)/bin"

# dotfiles
DOTFILES=$(find -H "$DOTFILESDIR" -maxdepth 3 -name '*.dotfile')
for file in $DOTFILES; do
    target="$HOME/.$(basename "$file" '.dotfile')"
    echo "Creating symlink for $file ($target)"
    rm -i -rf "$target"
    ln -s "$file" "$target"
done

# local bin files
if [ ! -d "$HOME/.local/bin" ]; then
    echo "Creating ~/local/bin"
    mkdir -p "$HOME/.local/bin"
fi

LOCALBINFILES=$(find -H "$LOCALBINFILESDIR" -maxdepth 999 2>/dev/null)
for file in $LOCALBINFILES; do
    target="$HOME/.local/bin/$(basename "$file")"
    echo "Creating symlink for $file ($target)"
    rm -i -rf "$target"
    ln -s "$file" "$target"
done

# config files
if [ ! -d "$HOME/.config" ]; then
    echo "Creating ~/.config"
    mkdir -p "$HOME/.config"
fi

CFGFILES=$(find -H "$CFGFILESDIR" -maxdepth 1 2>/dev/null)
for file in $CFGFILES; do
    target="$HOME/.config/$(basename "$file")"
    echo "Creating symlink for $file ($target)"
    rm -i -rf "$target"
    ln -s "$file" "$target"
done

echo "Done linking"