#!/usr/bin/env bash

# gets sudo permission
sudo -v

# list of apt repo
REPOS=(
    ppa:mmstick76/alacritty
)

for repo in "${REPOS[@]}"; do
    sudo add-apt-repository "$repo"
done

sudo apt update

# list of apt packages
PACKAGES=(
    git
    ninja-build
    vim
    meson
    alacritty
    xclip
)

# install packages
for package in "${PACKAGES[@]}"; do
    sudo apt install "$package"
done

sudo apt autoremove