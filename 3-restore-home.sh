#!/bin/bash
set -e

DIR_FEDORA="/home/fer/workspace/original/home-dirs/fedora"
DESTINO_HOME="$HOME/"

# Verificar que exista el directorio
if [ ! -d "$DIR_FEDORA" ]; then
    echo "Error: No existe el directorio $DIR_FEDORA"
    exit 1
fi

echo "=== RESTAURACIÓN DE HOME ==="
echo "Origen: $DIR_FEDORA/"
echo "Destino: $DESTINO_HOME"
echo ""
rsync -av --progress "$DIR_FEDORA/" "$DESTINO_HOME"

echo "Permisos a .kube y .ssh"

chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

chmod 700 ~/.kube
chmod 600 ~/.kube/*

echo "¡Restauración completada con éxito!"




# read -p "¿Estás seguro de que deseas sobrescribir los archivos de tu HOME? (s/N): " CONFIRMACION

# if [[ "$CONFIRMACION" =~ ^[Ss]$ ]]; then
#     echo "Restaurando archivos..."
#     rsync -av --progress "$DIR_FEDORA/" "$DESTINO_HOME"
#     echo "¡Restauración completada con éxito!"
# else
#     echo "Restauración cancelada."
# fi
