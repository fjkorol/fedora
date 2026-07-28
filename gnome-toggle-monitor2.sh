#!/bin/bash

#para depurar usar: gdctl show
#https://gemini.google.com/u/0/app/676ac55482e8cd3f?pageId=none

PRIMARY="DP-2"
SECONDARY="DP-4"


# Verificamos si SECONDARY está asignado como monitor lógico activo
if gdctl show | grep -A 10 "Logical monitor" | grep -q "$SECONDARY"; then
    # APAGAR SECUNDARIO
    # Volvemos a colocar el principal en el origen (0,0)
    gdctl set \
      --logical-monitor --primary --scale 1.3333333730697632 --x 0 --y 0 --monitor $PRIMARY --mode 3840x2160@119.999
else
    # ENCENDER SECUNDARIO
    # Secundario (escala 1.5): Ancho lógico = 1280px (de 0 a 1280 en X)
    # Principal debe empezar exactamente en X = 1280
    gdctl set \
      --logical-monitor --scale 1.5 --x 0 --y 900 --monitor $SECONDARY --mode 1920x1080@119.982 \
      --logical-monitor --primary --scale 1.3333333730697632 --x 1280 --y 0 --monitor $PRIMARY --mode 3840x2160@119.999
fi
