#!/usr/bin/env bash

sudo -v

sh $(pwd)/installers/essential_packages.sh
sh $(pwd)/installers/xmonad.sh
sh $(pwd)/installers/picom.sh
sh $(pwd)/installers/zsh_install.sh
sh $(pwd)/make_links.sh