#!/bin/bash

#Jetbrains mono
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

#gogh terminal gnome
bash -c  "$(wget -qO- https://git.io/vQgMr)" 

#Install starship for root usr
curl -sS https://starship.rs/install.sh | sh

# Adding the following to the end of ~/.bashrc for root user:
echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Download starship theme for root user
curl -o /root/.config/starship.toml https://raw.githubusercontent.com/keaguirre/Notebook/main/Assets/linux/starship.toml

source /root/.bashrc

#Install starship for non-root users
curl -sS https://starship.rs/install.sh | sh
#Adding the following to the end of ~/.bashrc for non-root users:
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Download starship theme for non-root users
curl -o ~/.config/starship.toml https://raw.githubusercontent.com/keaguirre/Notebook/main/Assets/linux/starship.toml

source ~/.bashrc

#ohMyPosh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)" #Install Jb Mono & configure terminal to use it
sudo apt install -y curl
curl -s https://ohmyposh.dev/install.sh | bash -s
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/amro.omp.json')"' >> ~/.bashrc
exec bash
