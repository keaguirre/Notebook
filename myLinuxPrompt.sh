#!/bin/bash

# Instalar la fuente JetBrains Mono
# Este script descarga e instala la fuente JetBrains Mono desde GitHub.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Instalar Gogh terminal para el entorno de escritorio GNOME
# Este script descarga e instala la extensión de terminal Gogh para GNOME.
bash -c "$(wget -qO- https://git.io/vQgMr)"

# Instalar el prompt Starship para el usuario root
# Esta sección instala y configura el prompt Starship para el usuario root.
curl -sS https://starship.rs/install.sh | sh  # Descargar y ejecutar el instalador de Starship

# Configurar Starship para el usuario root
echo 'eval "$(starship init bash)"' >> /root/.bashrc  # Añadir el script de inicialización al .bashrc de root
curl -o /root/.config/starship.toml https://raw.githubusercontent.com/keaguirre/Notebook/main/Assets/linux/starship.toml  # Descargar el archivo de tema

# Recargar la configuración de bash de root
source /root/.bashrc

# Instalar el prompt Starship para usuarios no root
# Similar a la sección del usuario root, esto instala y configura Starship para usuarios no root.
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> ~/.bashrc
curl -o ~/.config/starship.toml https://raw.githubusercontent.com/keaguirre/Notebook/main/Assets/linux/starship.toml

# Recargar la configuración de bash del usuario no root
source ~/.bashrc

# Instalar el prompt Oh My Posh
# Esta sección instala y configura el prompt Oh My Posh.

# Instalar la fuente JetBrains Mono (de nuevo)
# Esta línea parece redundante, ya que se instala al principio. Probablemente se pueda eliminar.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# Instalar Oh My Posh
sudo apt install -y curl  # Instalar curl si aún no está presente
curl -s https://ohmyposh.dev/install.sh | bash -s  # Descargar y ejecutar el instalador de Oh My Posh

# Configurar Oh My Posh para el usuario no root
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # Añadir la ruta de Oh My Posh al .bashrc del usuario
echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/xtoys.omp.json')"' >> ~/.bashrc  # Añadir el tema xtoys
echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/huvix.omp.json')"' >> ~/.bashrc  # Añadir el tema huvix

# Reiniciar bash para aplicar los cambios
exec bash

# Instalar Vim-Plug (gestor de plugins para Vim)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#Reload the file or restart Vim, then you can,
#    :PlugInstall to install the plugins
#    :PlugUpdate to install or update the plugins
#    :PlugDiff to review the changes from the last update
#    :PlugClean to remove plugins no longer in the list
#    Copilot inside vim needs nodejs installed previously visit -> https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
#    nvm install --lts
#    :Copilot setup para configurar copilot en vim 
# Descargar el archivo de configuración personalizado de Vim
# Asegúrate de tener Git instalado antes de ejecutar este comando.
sudo apt install git  # Instalar Git si aún no está presente
curl -fLo ~/.vimrc --create-dirs https://raw.githubusercontent.com/keaguirre/Notebook/main/.vimrc  # Descargar el .vimrc del usuario

# Descargar el archivo de configuración personalizado de Vim para el usuario root (opcional)
sudo curl -fLo /root/.vimrc --create-dirs https://raw.githubusercontent.com/keaguirre/Notebook/main/.vimrc

# Las instrucciones para configurar Copilot dentro de Vim se omiten.

# Instalar bat - resaltador de sintaxis para código
sudo yum install tar  # Instalar tar si aún no está presente (podría ser un gestor de paquetes diferente para tu distribución)
curl -o bat.zip -L https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-v0.18.2-x86_64-unknown-linux-musl.tar.gz  # Descargar el binario de bat
tar -xvzf bat.zip  # Extraer el archivo descargado
sudo mv bat-v0.18.2-x86_64-unknown-linux-musl /usr/local/bat  # Mover el binario de bat a la ubicación del sistema
echo 'alias bat="/usr/local/bat/bat"' >> ~/.bashrc  # Crear un alias para el comando bat
bat --version # Verificar la version de bat (se trunco en el original)

# Instalar Zoxide (Debian)
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
eval "$(zoxide init bash)"
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
