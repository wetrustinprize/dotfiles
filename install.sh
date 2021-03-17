#!/usr/bin/env bash

DOTFILESDIR="$(pwd)/dotfiles/"
CFGFILESDIR="$(pwd)/configs/"

# Ask for the administrator password upfront
sudo -v

zsh_install() {
	if [ -d "$HOME/.oh-my-zsh" ]; then
	    echo "Oh My Zsh already installed, skipping"
	else
	    echo "Installing Oh My Zsh"
	    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
}

make_links() {
	# dotfiles
	DOTFILES=$(find -H "$DOTFILESDIR" -maxdepth 3 -name '*.dotfile')
	for file in $DOTFILES; do
		target="$HOME/.$(basename "$file" '.dotfile')"
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
}

make_links

echo "Done."
