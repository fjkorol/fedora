#!/bin/bash

# 1. Instalar dependencias
# En Bazzite, git, curl y wget ya vienen. Zsh también suele venir.
# Si faltara algo, lo ideal es usar 'brew install' para evitar reiniciar el sistema.
#echo "--- Verificando ZSH ---"
#if ! command -v zsh &> /dev/null; then
#    echo "Zsh no encontrado. Instalando vía Homebrew..."
#    brew install zsh
#fi

# 2. Fuentes MesloLGS NF (Ruta local para Bazzite)
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
echo "--- Instalando fuentes MesloLGS NF ---"
fonts=("Regular" "Bold" "Italic" "Bold%20Italic")

for style in "${fonts[@]}"; do
    file_name="MesloLGS%20NF%20$style.ttf"
    clean_name=$(echo $file_name | sed 's/%20/ /g')
    if [ ! -f "$FONT_DIR/$clean_name" ]; then
        wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/$file_name" -P "$FONT_DIR"
    fi
done
# Actualizar cache de fuentes (esto funciona igual en Bazzite)
fc-cache -f

# 3. Oh My Zsh (Modo desatendido)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Instalando Oh My Zsh ---"
    KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# 4. Plugins y Powerlevel10k
echo "--- Descargando Plugins y Temas ---"
declare -A addons=(
    ["plugins/zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["plugins/zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["plugins/git-flow-completion"]="https://github.com/bobthecow/git-flow-completion"
    ["themes/powerlevel10k"]="https://github.com/romkatv/powerlevel10k.git"
)

for path in "${!addons[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/$path" ]; then
        git clone --depth=1 "${addons[$path]}" "$ZSH_CUSTOM/$path"
    fi
done

# 5. FZF (Instalación local)
if [ ! -d "$HOME/.fzf" ]; then
    echo "--- Instalando FZF ---"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
fi

# 6. Configuración de .zshrc
echo "--- Aplicando configuración en .zshrc ---"
# Asegurarnos de que el archivo existe
touch ~/.zshrc

# Cambiar tema
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Configurar plugins
if grep -q "plugins=(git)" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions git-flow-completion)/' ~/.zshrc
else
    # Si por alguna razón no está la línea, la agregamos
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions git-flow-completion)' >> ~/.zshrc
fi

# 7. Cambio de Shell en Bazzite/Fedora Atómica
# ¡OJO! chsh no funciona igual aquí. Se usa 'ujust' o 'lchsh'.
#echo "--- Cambiando shell predeterminado ---"
#if command -v ujust &> /dev/null; then
#    # Bazzite tiene un comando específico para esto
#    ujust configure-shell zsh
#else
#    sudo lchsh -s $(which zsh) $USER
#fi

echo "--- ¡Proceso finalizado! ---"
echo "TIP: En Bazzite, asegúrate de que tu terminal (Host) use 'MesloLGS NF'."
