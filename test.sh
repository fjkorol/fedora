#!/bin/bash


export GSETTINGS_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas"

echo "Aplicando configuración de pantalla y bloqueo..."

# 1. Apagar pantalla a los 5 minutos (300 segundos)
gsettings set org.gnome.desktop.session idle-delay 300

# 2. Desactivar el bloqueo automático de pantalla
gsettings set org.gnome.desktop.screensaver lock-enabled false

# 3. Retardo de bloqueo en 0 (Al apagarse la pantalla)
gsettings set org.gnome.desktop.screensaver lock-delay 0

# 4. Ocultar notificaciones en la pantalla de bloqueo
gsettings set org.gnome.desktop.notifications show-in-lock-screen false

# 5. Desactivar el bloqueo de pantalla al suspender el equipo
#VER FEDORA gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false

echo "¡Configuración aplicada con éxito!"


echo "Configurando Ubuntu Dock en el centro..."

# 1. Centrar el Dock (Desactivar modo panel / extender a bordes)
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true



# 3. Tamaño de iconos a 40px
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40

# 4. Posición abajo y en todos los monitores
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true

# 5. Ocultar dispositivos montados, de red y papelera
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

# 6.Ocultar monitor y workspace para app
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true

#siempre visible
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true

#usar todo el ancho
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true

gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'focus-minimize-or-appspread'

gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true

gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true

echo "¡Dock centrado y configurado correctamente!"
