#!/usr/bin/env bash

DOTFILES="$(pwd)/dotfiles/"

# Ask for the administrator password upfront
sudo -v

get_dotfiles() {
	find -H "$DOTFILES" -maxdepth 3 -name '*.dotfile'
}

zsh_install() {
	if [ -d "$HOME/.oh-my-zsh" ]; then
	    echo "Oh My Zsh already installed, skipping"
	else
	    echo "Installing Oh My Zsh"
	    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
}

make_links() {
	for file in $(get_dotfiles); do
		target="$HOME/.$(basename "$file" '.dotfile')"
		echo "Creating symlink for $file"
		rm -i -rf "$target"
		ln -s "$file" "$target"
	done
}

make_links

echo "Done."
