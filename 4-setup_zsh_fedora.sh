#!/bin/bash

set -e

#Incluido en 2
#echo "--- Instalando dependencias ---"
#sudo dnf install -y zsh git curl wget util-linux-user

# 1. Fuentes MesloLGS NF
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

fc-cache -f

# 2. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "--- Instalando Oh My Zsh ---"
    KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# 3. Plugins y tema
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

# 4. FZF (mejor usar dnf en Fedora)
echo "--- Instalando FZF ---"
sudo dnf install -y fzf

# 5. Configuración .zshrc
echo "--- Configurando .zshrc ---"
touch ~/.zshrc

# Tema
if grep -q "^ZSH_THEME=" ~/.zshrc; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi

# Plugins
PLUGINS_LINE='plugins=(git zsh-syntax-highlighting zsh-autosuggestions git-flow-completion)'

if grep -q "^plugins=" ~/.zshrc; then
    sed -i "s|^plugins=.*|$PLUGINS_LINE|" ~/.zshrc
else
    echo "$PLUGINS_LINE" >> ~/.zshrc
fi

# 6. Cambiar shell por defecto (válido en Fedora normal)
echo "--- Cambiando shell a zsh ---"
chsh -s $(which zsh)

echo "--- ¡Listo! ---"
echo "Reiniciá sesión o ejecutá: zsh"


#Backup configuración ptyxis
#dconf dump /org/gnome/Ptyxis/ > ptyxis_backup.ini

#Restaurar configuración ptyxis
dconf load /org/gnome/Ptyxis/ < ptyxis_backup.ini