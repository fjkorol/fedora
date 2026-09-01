#!/usr/bin/env zsh

FILE="$HOME/.p10k.zsh"
BACKUP="$HOME/.p10k.zsh.bak"

if [ ! -f "$FILE" ]; then
  echo "Error: No se encontró el archivo $FILE"
  exit 1
fi

# Guardar copia de respaldo
cp "$FILE" "$BACKUP"
echo "Respaldo creado en: $BACKUP"

# Aplicar las modificaciones
sed -i.tmp -E \
  -e 's/(\(\( \$#branch > )32( \)\) && branch\[13,-13\]="…")/\13200\2/' \
  -e 's/(\(\( \$#tag > )32( \)\) && tag\[13,-13\]="…")/\13200\2/' \
  "$FILE" && rm -f "${FILE}.tmp"

echo "¡Cambios aplicados correctamente!"