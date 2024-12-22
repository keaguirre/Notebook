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
echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/xtoys.omp.json')"' >> ~/.bashrc
echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/huvix.omp.json')"' >> ~/.bashrc
exec bash

#Install Vim-Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#descargar mi .vimrc
#Make sur to install git
sudo apt install git
curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/keaguirre/Notebook/main/.vimrc
sudo curl -fLo /root/.vimrc --create-dirs https://raw.githubusercontent.com/keaguirre/Notebook/main/.vimrc
# vim -> :PlugInstall -> reiniciar vim -> Copilot setup

#Install bat https://www.linode.com/docs/guides/how-to-install-and-use-the-bat-command-on-linux/
sudo yum install tar
curl -o bat.zip -L https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-v0.18.2-x86_64-unknown-linux-musl.tar.gz
tar -xvzf bat.zip
sudo mv bat-v0.18.2-x86_64-unknown-linux-musl /usr/local/bat
echo 'alias bat="/usr/local/bat/bat"' >> ~/.bashrc
bat --version

# Install Zoxide (Debian)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
eval "$(zoxide init bash)"echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
