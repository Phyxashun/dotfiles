#!/usr/bin/env fish
# Path to dotfiles repo (adjust if needed)
set DOTFILES_DIR ~/.dotfiles
set README_FILE $DOTFILES_DIR/README.md

# Ignore list
set IGNORE_LIST ".git" "misc" ".stow-local-ignore"

# Collect top-level directories excluding ignored files/folders
set PACKAGES
for d in $DOTFILES_DIR/*
    if test -d $d
        set name (basename $d)
        if not contains $name $IGNORE_LIST
            set PACKAGES $PACKAGES $name
        end
    end
end

# Start writing README
echo "# Phyxashun's Dotfiles

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=archlinux)](https://archlinux.org)  
[![Fish Shell](https://img.shields.io/badge/Shell-Fish-4EAA25?logo=fishshell)](https://fishshell.com)  
[![GNU Stow](https://img.shields.io/badge/Tool-GNU%20Stow-339933?logo=gnu)](https://www.gnu.org/software/stow/)

> Personal configuration repository for Arch Linux using Niri, DankMaterialShell, Fish, Ghostty, Starship, and more. Managed with GNU Stow.

---

## Packages / Configurations

| Package | Description |
|---------|-------------|" > $README_FILE

# Add each package to the table
for pkg in $PACKAGES
    set DESC "Auto-detected package folder"
    # Check for description.txt
    if test -f $DOTFILES_DIR/$pkg/description.txt
        set DESC (string trim (cat $DOTFILES_DIR/$pkg/description.txt))
    # Check for README.md inside the package
    else if test -f $DOTFILES_DIR/$pkg/README.md
        set DESC (string trim (head -n 1 $DOTFILES_DIR/$pkg/README.md))
    end
    echo "| $pkg | $DESC |" >> $README_FILE
end

# Append the rest of README content
echo "
---

## Setup Instructions

### Clone the repository

\`\`\`fish
git clone git@github.com:Phyxashun/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
\`\`\`

### Install prerequisites

\`\`\`fish
sudo pacman -S git stow fish starship neovim tmux bat btop
# Add any other tools you use (Niri, Ghostty, VSCode, etc.)
\`\`\`

### Apply dotfiles using Stow

\`\`\`fish
stow -vt ~ */
# Or specific packages:
stow -vt ~ fish nvim tmux starship
\`\`\`

### Optional: Restore dconf (if used)

\`\`\`fish
dconf load / < ~/.dotfiles/dconf/.config/dconf/user.conf
\`\`\`

---

## Updating & Syncing

\`\`\`fish
cd ~/.dotfiles
git add .
git commit -m \"describe changes\"
git push origin main

# On a new machine:
cd ~/.dotfiles
git pull origin main
stow -vt ~ */
\`\`\`

---

## License

MIT License — see [LICENSE](LICENSE) for details." >> $README_FILE

echo "README.md generated at $README_FILE"