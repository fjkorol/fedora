#!/bin/bash
set -e



#EXTENSIONES de GNOME
# OSK keyboard virtual GNOME:
# https://extensions.gnome.org/extension/5949/gjs-osk/

# reorder workspace
# https://extensions.gnome.org/extension/5090/space-bar/

# tray icon
# https://extensions.gnome.org/extension/615/appindicator-support/ 

#Vitals - extensión para ver el estado de la cpu, memoria, etc
#https://extensions.gnome.org/extension/1460/vitals/


#SOLO FEDORA

#tiling-assistant
#https://extensions.gnome.org/extension/3733/tiling-assistant/

#dash-to-dock/
#https://extensions.gnome.org/extension/307/dash-to-dock/


# Asegurar que el binario de pip esté en el PATH
export PATH="$HOME/.local/bin:$PATH"

# 1. Instalar gnome-extensions-cli si no existe
if ! command -v gext &> /dev/null; then
    echo "Instalando gnome-extensions-cli..."
    pip install --user gnome-extensions-cli
fi

# 2. Lista de IDs de las extensiones requeridas:
# 5949 -> GJS OSK
# 5090 -> Space Bar
# 615  -> AppIndicator and KStatusNotifierItem Support
# 1460 -> Vitals
# 3733 -> Tiling Assistant
# 307  -> Dash to Dock

EXTENSIONES=(3733 307 5949 5090 615 1460)

# 3. Instalación e instalación automática de cada extensión
echo "Instalando extensiones de GNOME..."
for id in "${EXTENSIONES[@]}"; do
    echo "Procesando extensión ID: $id"
    gext install "$id"
done

echo "¡Instalación completada con éxito!"



export GSETTINGS_SCHEMA_DIR="$HOME/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas"

# echo "Aplicando configuración de pantalla y bloqueo..."

# # 1. Apagar pantalla a los 5 minutos (300 segundos)
# gsettings set org.gnome.desktop.session idle-delay 300

# # 2. Desactivar el bloqueo automático de pantalla
# gsettings set org.gnome.desktop.screensaver lock-enabled false

# # 3. Retardo de bloqueo en 0 (Al apagarse la pantalla)
# gsettings set org.gnome.desktop.screensaver lock-delay 0

# # 4. Ocultar notificaciones en la pantalla de bloqueo
# gsettings set org.gnome.desktop.notifications show-in-lock-screen false

# # 5. Desactivar el bloqueo de pantalla al suspender el equipo
# #VER FEDORA gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false

# echo "¡Configuración aplicada con éxito!"


# echo "Configurando Ubuntu Dock en el centro..."

# # 1. Centrar el Dock (Desactivar modo panel / extender a bordes)
# gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true



# # 3. Tamaño de iconos a 40px
# gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40

# # 4. Posición abajo y en todos los monitores
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
# gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true

# # 5. Ocultar dispositivos montados, de red y papelera
# gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
# gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false

# # 6.Ocultar monitor y workspace para app
# gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true
# gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true

# #siempre visible
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true

# #usar todo el ancho
# gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true

# gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'focus-minimize-or-appspread'

# gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true

# gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme true

# echo "¡Dock centrado y configurado correctamente!"



#Take a screenshot interactively
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>s']"
#Home folder
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"



## DASH TO DOCK
#Dumpear
#dconf dump /org/gnome/shell/extensions/dash-to-dock/ > dash-to-dock-config.txt

#restablecer
dconf load /org/gnome/shell/extensions/dash-to-dock/ < dash-to-dock-config.txt


## VITALS
#Dumpear
#dconf dump /org/gnome/shell/extensions/vitals/ > vitals-config.txt

#restablecer
dconf load /org/gnome/shell/extensions/vitals/ < vitals-config.txt


#Pentaho / Spoon
#sudo apt install -y openjdk-11-jdk
