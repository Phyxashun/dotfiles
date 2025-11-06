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

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)  
[![Fish Shell](https://img.shields.io/badge/Shell-Fish-4EAA25?logo=fishshell)](https://fishshell.com)  
[![GNU Stow](https://img.shields.io/badge/Tool-GNU%20Stow-339933?logo=gnu)](https://www.gnu.org/software/stow/)

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