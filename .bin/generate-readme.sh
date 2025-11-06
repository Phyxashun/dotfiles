#!/bin/sh
# Path to dotfiles repo (adjust if needed)
DOTFILES_DIR="$HOME/.dotfiles"
README_FILE="$DOTFILES_DIR/README.md"

# Ignore list
IGNORE_LIST=".git misc .stow-local-ignore"

# Collect top-level directories excluding ignored files/folders
PACKAGES=""
for d in "$DOTFILES_DIR"/*; do
    if [ -d "$d" ]; then
        name=$(basename "$d")
        # Check if name is in ignore list
        skip=0
        for ignore in $IGNORE_LIST; do
            if [ "$name" = "$ignore" ]; then
                skip=1
                break
            fi
        done
        if [ $skip -eq 0 ]; then
            PACKAGES="$PACKAGES $name"
        fi
    fi
done

# Start writing README
cat > "$README_FILE" << 'EOF'
# Phyxashun's Dotfiles

# Dotfiles Badges

## Window Manager & Desktop
[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)
[![Niri](https://img.shields.io/badge/WM-Niri-7C3AED?logo=wayland)](https://github.com/YaLTeR/niri)
[![Wayland](https://img.shields.io/badge/Protocol-Wayland-FFBC00?logo=wayland)](https://wayland.freedesktop.org/)

## Terminals
[![Ghostty](https://img.shields.io/badge/Terminal-Ghostty-FF6B6B?logo=gnometerminal)](https://github.com/ghostty-org/ghostty)
[![WezTerm](https://img.shields.io/badge/Terminal-WezTerm-4E49EE?logo=windowsterminal)](https://wezfurlong.org/wezterm/)
[![Alacritty](https://img.shields.io/badge/Terminal-Alacritty-F46D01?logo=alacritty)](https://alacritty.org/)
[![Kitty](https://img.shields.io/badge/Terminal-Kitty-00ADD8?logo=gnometerminal)](https://sw.kovidgoyal.net/kitty/)

## Shell & Prompt
[![Starship](https://img.shields.io/badge/Prompt-Starship-DD0B78?logo=starship)](https://starship.rs/)

## Browsers
[![Firefox](https://img.shields.io/badge/Browser-Firefox-FF7139?logo=firefox)](https://www.mozilla.org/firefox/)
[![Zen Browser](https://img.shields.io/badge/Browser-Zen-6366F1?logo=firefoxbrowser)](https://zen-browser.app/)

## Productivity
[![Geary](https://img.shields.io/badge/Mail-Geary-4A90D9?logo=gnome)](https://wiki.gnome.org/Apps/Geary)
[![GNOME Calculator](https://img.shields.io/badge/Calculator-GNOME-4A86CF?logo=gnome)](https://wiki.gnome.org/Apps/Calculator)
[![Nautilus](https://img.shields.io/badge/Files-Nautilus-4A86CF?logo=gnome)](https://wiki.gnome.org/Apps/Files)

## System Tools
[![PulseAudio](https://img.shields.io/badge/Audio-PulseAudio-DC143C?logo=pulseaudio)](https://www.freedesktop.org/wiki/Software/PulseAudio/)
[![NetworkManager](https://img.shields.io/badge/Network-NetworkManager-0078D4?logo=linux)](https://networkmanager.dev/)
[![Blueman](https://img.shields.io/badge/Bluetooth-Blueman-0082FC?logo=bluetooth)](https://github.com/blueman-project/blueman)
[![Polkit MATE](https://img.shields.io/badge/Auth-Polkit%20MATE-87CF3E?logo=linux)](https://github.com/mate-desktop/mate-polkit)

## Utilities
[![cliphist](https://img.shields.io/badge/Clipboard-cliphist-6366F1?logo=clipboard)](https://github.com/sentriz/cliphist)
[![Steam](https://img.shields.io/badge/Gaming-Steam-000000?logo=steam)](https://store.steampowered.com/)
[![Zoom](https://img.shields.io/badge/Video-Zoom-2D8CFF?logo=zoom)](https://zoom.us/)

## Desktop Environment
[![Qt](https://img.shields.io/badge/Framework-Qt-41CD52?logo=qt)](https://www.qt.io/)
[![GTK3](https://img.shields.io/badge/Toolkit-GTK3-4A86CF?logo=gnome)](https://www.gtk.org/)

## Custom Tools
[![DMS](https://img.shields.io/badge/Desktop-DMS-8B5CF6?logo=linux)](https://github.com/yourusername/dms)
[![QuickShell](https://img.shields.io/badge/Shell-QuickShell-06B6D4?logo=linux)](https://github.com/outfoxxed/quickshell)

> Personal configuration repository for Arch Linux using Niri, DankMaterialShell, Fish, Ghostty, Starship, and more. Managed with GNU Stow.

---

## Packages / Configurations

| Package | Description |
|---------|-------------|
EOF

# Add each package to the table
for pkg in $PACKAGES; do
    DESC="Auto-detected package folder"
    # Check for description.txt
    if [ -f "$DOTFILES_DIR/$pkg/description.txt" ]; then
        DESC=$(cat "$DOTFILES_DIR/$pkg/description.txt" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    # Check for README.md inside the package
    elif [ -f "$DOTFILES_DIR/$pkg/README.md" ]; then
        DESC=$(head -n 1 "$DOTFILES_DIR/$pkg/README.md" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    fi
    echo "| $pkg | $DESC |" >> "$README_FILE"
done

# Append the rest of README content
cat >> "$README_FILE" << 'EOF'

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
EOF

echo "README.md generated at $README_FILE"