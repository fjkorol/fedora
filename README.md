# 🚀 Fedora & Bazzite Setup Scripts

Colección de scripts de automatización para post-instalación de **Fedora KDE** y sistemas basados en **Fedora Atomic (Bazzite)**.

Este repositorio está pensado para dejar un sistema listo para **Gaming**, **Desarrollo** y con una **Terminal enriquecida (Zsh + Powerlevel10k)** en cuestión de minutos.

---

## 🛠️ Contenido del Repositorio

| Archivo | Descripción | Uso principal |
| :--- | :--- | :--- |
| `01-sudoers.sh` | Opcional: Otorga permisos `NOPASSWD` a `sudo` para el usuario `fer`. | Configuración inicial |
| `02-fedora-setup.sh` | Script maestro de optimización, códecs, drivers, apps y juegos. | Fedora Workstation / KDE |
| `03-zsh-fedora.sh` | Configuración de Zsh + Oh My Zsh + Powerlevel10k vía `dnf`. | Fedora tradicional |
| `04-zsh-bazzite.sh` | Configuración de Zsh + Oh My Zsh + Powerlevel10k sin modificar raíz. | Bazzite / Fedora Atomic |

---

## ⚙️ ¿Qué realiza cada script?

### 📦 1. `02-fedora-setup.sh` (Fedora Standard / Workstation)
* **Optimización de DNF5:** Descargas en paralelo (`max_parallel_downloads=10`), `fastestmirror` y confirmación automática.
* **Repositorios:** Habilita RPM Fusion (Free & Nonfree) y Flathub.
* **Multimedia:** Reemplaza FFmpeg libre por la versión completa, instala códecs multimedia y soporte de aceleración por hardware (VA-API / VDPAU para AMD/Intel).
* **Controladores Gráficos:** Soporte Vulkan/OpenGL (32 y 64 bits) y detección/instalación automática de drivers propietarios **NVIDIA** (`akmod-nvidia`).
* **Gaming Suite:**
  * Herramientas: GameMode, MangoHud, GOverlay, Gamescope, Protontricks, Winetricks.
  * Ajustes de Kernel: `vm.max_map_count = 1048576` y `vm.swappiness = 10`.
  * Launchers: Steam, Lutris, Heroic Games Launcher, ProtonUp-Qt, Bottles.
* **Software de desarrollo y CLI:** Git, Git-LFS, Neovim, Fish, FZF, Ripgrep, Bat, Eza, Zoxide, compiladores (`gcc`, `make`, `cmake`), VS Code, Google Chrome (Stable/Beta), Tailscale y más.

---

### 🐚 2. Zsh + Oh My Zsh + Powerlevel10k

#### Opción A: Fedora Tradicional (`03-zsh-fedora.sh`)
* Descarga e instala la fuente **MesloLGS NF** (Nerd Fonts).
* Instala Oh My Zsh de forma desatendida.
* Instala plugins esenciales (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `git-flow-completion`).
* Aplica el tema **Powerlevel10k**.
* Cambia la Shell predeterminada del usuario mediante `chsh`.

#### Opción B: Bazzite / Fedora Atomic (`04-zsh-bazzite.sh`)
* Diseñado para sistemas con sistema de archivos inmutable/atómico.
* Instala fuentes y plugins localmente en `$HOME` sin requerir modificaciones en la raíz del sistema.
* Instala `fzf` de manera aislada localmente.

---

## 🚀 Instrucciones de Uso

### 1. Clonar el repositorio
```bash
git clone [https://github.com/TU_USUARIO/TU_REPOSO.git](https://github.com/TU_USUARIO/TU_REPOSO.git)
cd TU_REPOSO
chmod +x *.sh
