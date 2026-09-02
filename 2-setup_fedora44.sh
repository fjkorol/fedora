#!/usr/bin/env bash
set -e



#mover dir personal a workspace

rm -rf "$HOME/Documents"
rm -rf "$HOME/Downloads"
rm -rf "$HOME/Pictures"
rm -rf "$HOME/Videos"
rm -rf "$HOME/Music"
rm -rf "$HOME/Templates"
rm -rf "$HOME/Public"
rm -rf "$HOME/Desktop"


ln -s "$HOME/workspace/personal/Documents" "$HOME/Documents"
ln -s "$HOME/workspace/personal/Downloads" "$HOME/Downloads"
ln -s "$HOME/workspace/personal/Pictures" "$HOME/Pictures"
ln -s "$HOME/workspace/personal/Videos" "$HOME/Videos"
ln -s "$HOME/workspace/personal/Music" "$HOME/Music"
ln -s "$HOME/workspace/personal/Templates" "$HOME/Templates"
ln -s "$HOME/workspace/personal/Public" "$HOME/Public"
ln -s "$HOME/workspace/personal/Desktop" "$HOME/Desktop"



# 8. Google Chrome y Visual Studio Code
echo "--> Instalando Google Chrome y Visual Studio Code..."

# Repositorio oficial de Google Chrome
if ! rpm -q google-chrome-stable >/dev/null 2>&1; then
    sudo tee /etc/yum.repos.d/google-chrome.repo >/dev/null <<'EOF'
[google-chrome]
name=Google Chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
fi

# Repositorio oficial de Visual Studio Code
if ! rpm -q code >/dev/null 2>&1; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

    sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
fi

sudo dnf install -y \
    google-chrome-stable \
    google-chrome-beta \
    code






# 5. Controladores e infraestructuras de renderizado (32 bits y 64 bits)
echo "--> Instalando paquetes de Vulkan, OpenGL y dependencias de 32 bits..."
sudo dnf install -y \
    vulkan-loader \
    vulkan-loader.i686 \
    vulkan-tools \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers.i686 \
    mesa-dri-drivers \
    mesa-dri-drivers.i686 \
    libva-utils \
    glibc-devel.i686 \
    libstdc++.i686


# Detección de tarjeta gráfica NVIDIA
if lspci | grep -i nvidia > /dev/null; then
    echo "--> Placa NVIDIA detectada: Instalando controladores propietarios AKMOD..."
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs.i686
fi

# 6. Herramientas de Rendimiento y Optimización Gaming
echo "--> Instalando GameMode, MangoHud y GOverlay..."
sudo dnf install -y \
    gamescope \
    mangohud \
    gamemode \
    goverlay \
    protontricks \
    winetricks


# 7. Ajustes del Kernel para Juegos
echo "--> Aplicando ajustes de memoria sysctl (vm.max_map_count)..."

sudo bash -c 'cat <<EOF > /etc/sysctl.d/99-gaming.conf
# Aumentar límite de mapas de memoria para juegos modernos y Proton
vm.max_map_count = 1048576
# Mejorar reactividad bajo carga de memoria
vm.swappiness = 10
EOF'
sudo sysctl --system

# 8. Instalación de Clientes y Gestores de Juegos (RPM + Flatpak)
echo "--> Instalando launchers de juegos..."
sudo dnf install -y steam lutris

# Herramientas adicionales en Flatpak
flatpak install -y flathub com.heroicgameslauncher.hgl    # Heroic (Epic, GOG, Amazon)
flatpak install -y flathub net.davidotek.pupgui2          # ProtonUp-Qt (Para GE-Proton)
flatpak install -y flathub com.usebottles.bottles        # Bottles
flatpak install -y flathub com.mattjakeman.ExtensionManager # Extension Manager (Flatpak)
flatpak install -y flathub net.nokyan.Resources #Resources
flatpak install -y flathub com.rtosta.zapzap

echo "--> Herramientas basicas..."


sudo dnf install -y \
    git \
    git-lfs \
    curl \
    wget \
    unzip \
    zip \
    jq \
    htop \
    btop \
    fastfetch \
    neovim \
    fish \
    fzf \
    ripgrep \
    fd-find \
    bat \
    eza \
    zoxide \
    gcc \
    gcc-c++ \
    make \
    cmake



echo "--> Instalando herramientas adicionales..."

sudo dnf install -y \
    vlc \
    geany \
    mc \
    gimp \
    meld \
    guake \
    powertop \
    nmap \
    zsh \
    unrar \
    autoconf \
    telegram-desktop \
    vim-enhanced \
    sysbench \
    dkms \
    kubernetes-client \
    links \
    msr-tools \
    stress \
    direnv \
    python3-build \
    kdiskmark \
    python3-pip \
    postgresql \
    fio \
    python3-devel \
    bsdtar













sudo rpm --import https://rpm.opera.com/rpmrepo.key

rpm -q gpg-pubkey --qf '%{VERSION}-%{RELEASE}\n' | grep -Ei '^6c86be214648376680ca957b11ee8c00b693a745-'


printf '%s\n' \
'[opera]' \
'name=Opera packages' \
'type=rpm-md' \
'baseurl=https://rpm.opera.com/rpm' \
'gpgcheck=1' \
'gpgkey=https://rpm.opera.com/rpmrepo.key' \
'enabled=1' | sudo tee /etc/yum.repos.d/opera.repo > /dev/null


dnf repo list --enabled | grep -E '^opera[[:space:]]'

sudo dnf install opera-stable





# -----------------------------------------------------------------------------
# Instalación de Docker en Fedora
# -----------------------------------------------------------------------------

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo gpasswd -a $USER docker




sudo systemctl enable --now sshd.service






echo "--> Instalando Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh




echo "--> Verificando aceleración multimedia..."

if vainfo >/dev/null 2>&1; then
    echo "✓ VA-API funcionando"
else
    echo "✗ VA-API no disponible"
fi

if ffmpeg -hide_banner -encoders | grep -q h264_vaapi; then
    echo "✓ FFmpeg con soporte VAAPI"
else
    echo "✗ FFmpeg sin soporte VAAPI"
fi

if vulkaninfo --summary >/dev/null 2>&1; then
    echo "✓ Vulkan funcionando"
else
    echo "✗ Vulkan no disponible"
fi



