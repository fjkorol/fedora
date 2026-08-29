#!/usr/bin/env bash
set -e

# --- Configuración de rutas ---
INSTALL_DIR="$HOME/workspace/original"
APP_DIR="$INSTALL_DIR/lm-studio"
DESKTOP_FILE="$HOME/.local/share/applications/LM-Studio.desktop"
TEMP_APPIMAGE="/tmp/LM-Studio-latest.AppImage"

# URL directa de descarga para Linux x64
DOWNLOAD_URL="https://lmstudio.ai/download/latest/linux/x64"

echo "=== Iniciando instalación / actualización de LM Studio ==="

# 1. Asegurar que existe el directorio de trabajo
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# 2. Descargar la última versión
echo "--> Descargando la última versión..."
curl -L -# -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64)" -o "$TEMP_APPIMAGE" "$DOWNLOAD_URL"

# Verificar que se descargó un ejecutable válido y no una página web de error
if ! file "$TEMP_APPIMAGE" | grep -qE 'AppImage|executable|ELF'; then
    echo "Error: El archivo descargado no es un ejecutable válido. Revisa el enlace o la conexión."
    rm -f "$TEMP_APPIMAGE"
    exit 1
fi

chmod +x "$TEMP_APPIMAGE"

# 3. Limpiar versión anterior si existe
if [ -d "$APP_DIR" ]; then
    echo "--> Removiendo la versión anterior..."
    rm -rf "$APP_DIR"
fi

# 4. Extraer el AppImage
echo "--> Extrayendo el paquete..."
"$TEMP_APPIMAGE" --appimage-extract > /dev/null
mv squashfs-root "$APP_DIR"

# Limpiar el AppImage temporal de /tmp
rm -f "$TEMP_APPIMAGE"

# 5. Configurar los permisos requeridos para chrome-sandbox
echo "--> Configurando permisos del chrome-sandbox (requiere sudo)..."
sudo chown root:root "$APP_DIR/chrome-sandbox"
sudo chmod 4755 "$APP_DIR/chrome-sandbox"

# 6. Crear el archivo .desktop si no existe
if [ ! -f "$DESKTOP_FILE" ]; then
    echo "--> Creando acceso directo LM-Studio.desktop..."

    mkdir -p "$(dirname "$DESKTOP_FILE")"

    cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=LM Studio
Type=Application
Exec=$APP_DIR/lm-studio %U
Icon=$APP_DIR/lm-studio.png
Terminal=false
Categories=Utility;
StartupWMClass=LM-Studio
MimeType=x-scheme-handler/lmstudio;
EOF

    echo "--> Acceso directo creado en: $DESKTOP_FILE"
else
    echo "--> El acceso directo ya existe, se mantiene la configuración."
fi

echo "=== ¡LM Studio ha sido actualizado/instalado correctamente! ==="
