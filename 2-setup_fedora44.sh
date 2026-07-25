#!/usr/bin/env bash
set -e

echo "=== Configurando Fedora 44 KDE para Gaming ==="

# 1. Optimizar DNF5 para descargas más rápidas
echo "--> Configurando DNF..."
sudo bash -c 'cat <<EOF >> /etc/dnf/dnf.conf
max_parallel_downloads=10
fastestmirror=true
defaultyes=true
EOF'

# 2. Habilitar RPM Fusion (Free y Nonfree) y Flathub
echo "--> Habilitando repositorios (RPM Fusion y Flathub)..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. Actualizar la base del sistema
echo "--> Actualizando el sistema..."
sudo dnf upgrade --refresh -y

# 4. Instalación de Códecs Multimedia completos (Mesa Freeworld / FFmpeg)
echo "--> Instalando códecs de video e integración multimedia..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

sudo dnf install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin


# Aceleración por hardware VA-API/VDPAU en AMD e Intel
sudo dnf install -y mesa-va-drivers-freeworld

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
    sudo dnf install -y akmod-nvidia
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
    ktorrent \
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


echo "=========================================================="
echo " ¡Configuración completada con éxito!"
echo " RECOMENDACIÓN: Reinicia el sistema para aplicar los"
echo " controladores, parches del kernel y grupos de usuarios."
echo "=========================================================="


echo "--> Instalando Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh


