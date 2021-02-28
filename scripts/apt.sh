# Update APT
sudo apt update

# Pacakges to install
packages=(
    python3
    pip3
    nodejs
    npm
)

for pacakge in "${packages[@]}"; do
    sudo apt install "$package"
done