# Phyxashun's Dotfiles


[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)

[![Niri](https://img.shields.io/badge/Niri-Window_Manager-7C3AED?style=for-the-badge&logo=wayland&logoColor=white)] (https://github.com/YaLTeR/niri) 
[![Wayland](https://img.shields.io/badge/Wayland-Display_Protocol-FFBC00?style=for-the-badge&logo=wayland&logoColor=black)] (https://wayland.freedesktop.org)


[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)
[![Niri](https://img.shields.io/badge/WM-Niri-7C3AED?logo=wayland)](https://github.com/YaLTeR/niri)
[![Wayland](https://img.shields.io/badge/Protocol-Wayland-FFBC00?logo=wayland)](https://wayland.freedesktop.org/)
[![Ghostty](https://img.shields.io/badge/Terminal-Ghostty-FF6B6B?logo=gnometerminal)](https://github.com/ghostty-org/ghostty)
[![Fish Shell](https://img.shields.io/badge/Shell-Fish-4EAA25?logo=fishshell)](https://fishshell.com)  
[![Starship](https://img.shields.io/badge/Prompt-Starship-DD0B78?logo=starship)](https://starship.rs/)
[![DMS](https://img.shields.io/badge/Desktop-DMS-8B5CF6?logo=linux)](https://github.com/yourusername/dms)
[![QuickShell](https://img.shields.io/badge/Shell-QuickShell-06B6D4?logo=linux)](https://github.com/outfoxxed/quickshell)
[![GNU Stow](https://img.shields.io/badge/Tool-GNU%20Stow-339933?logo=gnu)](https://www.gnu.org/software/stow/)

> Personal configuration repository for Arch Linux using Niri, DankMaterialShell, Fish, Ghostty, Starship, and more. Managed with GNU Stow.

---

## Packages / Configurations

| Package | Description |
|---------|-------------|
| dconf | Auto-detected package folder |
| pkglist | Auto-detected package folder |

---

## Setup Instructions

### Clone the repository

```sh
git clone git@github.com:Phyxashun/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Install prerequisites

```sh
sudo pacman -S git stow fish starship neovim tmux bat btop
# Add any other tools you use (Niri, Ghostty, VSCode, etc.)
```

### Apply dotfiles using Stow

```sh
stow -vt ~ */
# Or specific packages:
stow -vt ~ fish nvim tmux starship
```

### Optional: Restore dconf (if used)

```sh
dconf load / < ~/.dotfiles/dconf/.config/dconf/user.conf
```

---

## Updating & Syncing

```sh
cd ~/.dotfiles
git add .
git commit -m "describe changes"
git push origin main

# On a new machine:
cd ~/.dotfiles
git pull origin main
stow -vt ~ */
```

---

## License

MIT License — see [LICENSE](LICENSE) for details.
