# Update SNAP
sudo snap refresh

# Pacakges to install
packages=(
    code
)

for pacakge in "${packages[@]}"; do
    sudo snap install --classic "$package"
done