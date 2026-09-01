#!/bin/bash
set -e

# Habilitar pegar click central
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true

# Actualización inicial
sudo dnf upgrade -y

# Paquetes básicos
sudo dnf install -y git openssh-clients curl unzip zsh p7zip p7zip-plugins make gcc


# Mover dir personal a workspace
rm -rf "$HOME/Documents" "$HOME/Downloads" "$HOME/Pictures" "$HOME/Videos" "$HOME/Music" "$HOME/Templates" "$HOME/Public" "$HOME/Desktop"

ln -s "$HOME/workspace/personal/Documents" "$HOME/Documents"
ln -s "$HOME/workspace/personal/Downloads" "$HOME/Downloads"
ln -s "$HOME/workspace/personal/Pictures" "$HOME/Pictures"
ln -s "$HOME/workspace/personal/Videos" "$HOME/Videos"
ln -s "$HOME/workspace/personal/Music" "$HOME/Music"
ln -s "$HOME/workspace/personal/Templates" "$HOME/Templates"
ln -s "$HOME/workspace/personal/Public" "$HOME/Public"
ln -s "$HOME/workspace/personal/Desktop" "$HOME/Desktop"

# Definir variables de ruta
ORIGEN="/home/fer/workspace/original/ubuntu/personal/.config/user-dirs.dirs"
DESTINO="$HOME/.config/user-dirs.dirs"

# Comprobar si el archivo de origen existe
if [ -f "$ORIGEN" ]; then
    mkdir -p "$HOME/.config"
    cp "$ORIGEN" "$DESTINO"
    echo "Archivo copiado y reemplazado con éxito en $DESTINO"
else
    echo "Error: El archivo de origen no existe en $ORIGEN"
fi

xdg-user-dirs-update


# Configuración de Git
git config --global credential.helper store
git config --global core.editor "nano"
git config --global user.email "ferkorol@gmail.com"
git config --global user.name "Fernando Korol"

# -----------------------------------------------------------------------------
# Instalación de Docker en Fedora
# -----------------------------------------------------------------------------
echo "Instalación de DOCKER..."
sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo gpasswd -a $USER docker

# -----------------------------------------------------------------------------
# Herramientas de GNOME CLI
# -----------------------------------------------------------------------------
pipx ensurepath
pipx install gnome-extensions-cli

# -----------------------------------------------------------------------------
# Node.js (vía NVM)
# -----------------------------------------------------------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 24
node -v
npm -v

# Qwen Code Terminal
curl -fsSL https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen-standalone.sh | bash

# ZapZap (Flatpak)
flatpak install -y flathub com.rtosta.zapzap
flatpak override --user --filesystem=home com.rtosta.zapzap

# -----------------------------------------------------------------------------
# Warp Terminal (Fedora RPM Repo)
# -----------------------------------------------------------------------------
echo "--> Instalando Warp Terminal..."
sudo rpm --import https://releases.warp.dev/linux/keys/warp.asc
echo -e "[warpdotdev]\nname=warpdotdev\nbaseurl=https://releases.warp.dev/linux/rpm/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://releases.warp.dev/linux/keys/warp.asc" | sudo tee /etc/yum.repos.d/warpdotdev.repo > /dev/null
sudo dnf install -y warp-terminal

# -----------------------------------------------------------------------------
# Syncthing
# -----------------------------------------------------------------------------
echo "--> Instalando Syncthing..."
sudo dnf install -y syncthing
systemctl --user enable syncthing.service
systemctl --user start syncthing.service

# -----------------------------------------------------------------------------
# Tailscale
# -----------------------------------------------------------------------------
echo "--> Instalando Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "¡Instalación completada correctamente en Fedora!"
