#!/bin/bash
set -e

# Habilitar pegar click central
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true

# Actualización inicial
sudo dnf upgrade -y

# Paquetes básicos
sudo dnf install -y git openssh-clients curl unzip zsh p7zip p7zip-plugins make gcc rar unrar pkgconf-pkg-config
sudo dnf groupinstall -y "Development Tools"

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

echo "Aplicando configuración de pantalla y bloqueo..."
gsettings set org.gnome.desktop.session idle-delay 300
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver lock-delay 0
gsettings set org.gnome.desktop.notifications show-in-lock-screen false
echo "¡Configuración aplicada con éxito!"

echo "Configurando GNOME Dash / Dock..."
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
echo "¡Dock configurado correctamente!"

# -----------------------------------------------------------------------------
# Google Chrome, VS Code y Opera Repositorios
# -----------------------------------------------------------------------------
echo "--> Configurando repositorios para Chrome, VS Code y Opera..."

# Google Chrome (usualmente incluido en Fedora Workstation Third-Party Repos, aseguramos su activación)
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

# Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# Opera
sudo rpm --import https://deb.opera.com/archive.key
sudo dnf config-manager --add-repo https://rpm.opera.com/rpm/

# -----------------------------------------------------------------------------
# Instalar Navegadores y VS Code
# -----------------------------------------------------------------------------
sudo dnf install -y google-chrome-stable code opera-stable

# -----------------------------------------------------------------------------
# Paquetes complementarios en Fedora
# -----------------------------------------------------------------------------
sudo dnf install -y \
    postgresql \
    meld \
    vlc \
    git-flow \
    gnome-shell-extension-common \
    gnome-browser-connector \
    geany \
    mc \
    htop \
    deluge \
    powertop \
    nmap \
    gnome-tweaks \
    cpu-x \
    gnome-system-monitor \
    stress \
    fuse-libs \
    fzf \
    flatpak \
    direnv \
    pipx

echo "Configurando Flatpak y Flathub..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub \
com.getpostman.Postman \
org.pgadmin.pgadmin4 \
info.febvre.Komikku \
com.vivaldi.Vivaldi \
net.waterfox.waterfox \
org.telegram.desktop \
com.obsproject.Studio \
io.github.chidiwilliams.Buzz \
org.zotero.Zotero

# -----------------------------------------------------------------------------
# LM Studio (Descarga de AppImage / RPM para Fedora vía Flatpak o direct binary)
# Note: LM Studio provee AppImage / Flatpak oficialmente para RPM-based distros.
# -----------------------------------------------------------------------------
echo "--> Instalando LM Studio en formato AppImage..."
mkdir -p "$HOME/Applications"
curl -fL "https://lmstudio.ai/download/latest/linux/x64" -o "$HOME/Applications/LM_Studio.AppImage"
chmod +x "$HOME/Applications/LM_Studio.AppImage"

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
