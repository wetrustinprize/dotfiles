#!/usr/bin/env bash

sudo -v

sh $(pwd)/essential_packages.sh
sh $(pwd)/xmonad.sh
sh $(pwd)/picom.sh
sh $(pwd)/zsh_install.sh
sh $(pwd)/make_links.sh