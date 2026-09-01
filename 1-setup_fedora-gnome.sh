#!/usr/bin/env bash
set -e

echo "=== Configurando Fedora 44 KDE para Gaming ==="

#habilitar pegar click central
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste true


# 1. Optimizar DNF5 para descargas más rápidas
echo "--> Configurando DNF..."
sudo bash -c 'cat <<EOF >> /etc/dnf/dnf.conf
max_parallel_downloads=10
fastestmirror=true
defaultyes=true
EOF'

# 2. Habilitar RPM Fusion (Free y Nonfree) Flathub y
echo "--> Habilitando repositorios (RPM Fusion y Flathub)..."
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 3. Actualizar la base del sistema
echo "--> Actualizando el sistema..."
sudo dnf upgrade --refresh -y






# 4. Instalación de Códecs Multimedia completos (Mesa Freeworld / FFmpeg)
echo "--> Instalando códecs de video e integración multimedia..."
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

sudo dnf install -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin


# Aceleración por hardware VA-API/VDPAU en AMD e Intel
sudo dnf install -y mesa-va-drivers-freeworld
