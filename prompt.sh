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
curl -o /root/.config/starship.toml https://raw.githubusercontent.com/keaguirre/LinuxCheatSheet/main/starship.toml

exec bash

#Install starship for non-root users
curl -sS https://starship.rs/install.sh | sh
#Adding the following to the end of ~/.bashrc for non-root users:
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Download starship theme for non-root users
curl -o ~/.config/starship.toml https://raw.githubusercontent.com/keaguirre/LinuxCheatSheet/main/starship.toml

exec bash