#!/bin/bash

# Verificar si el script se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script con sudo o como root."
  exit 1
fi

# Añadir la regla al final de /etc/sudoers
echo "fer ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "Regla añadida a /etc/sudoers."
