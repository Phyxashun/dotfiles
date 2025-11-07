#!/usr/bin/env fish

# ~/.config/fish/config.fish
# Optimized for Arch Linux + Niri

# Suppress fish greeting
set -g fish_greeting

# ============================================
# Tool Installation
# ============================================

# Add a setup completion flag
set -l SETUP_FLAG ~/.config/fish/.setup_complete

if status is-interactive; and not test -f $SETUP_FLAG
    initial-setup
end

# ============================================
# Environment Variables
# ============================================
set -gx USER "Dusty Dew"
set -gx EMAIL "phyxashun@gmail.com"
set -gx GIT_BRANCH main
set -gx MOZ_ENABLE_WAYLAND 1
set -gx QT_QPA_PLATFORM wayland
set -gx SDL_VIDEODRIVER wayland
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx CLUTTER_BACKEND wayland
set -gx GDK_BACKEND wayland
set -gx LANG en_US.UTF-8
set -gx EDITOR nvim
set -gx VISUAL code
set -gx TERM tmux-256color
set -gx SSH_AUTH_SOCK /home/phyxashun/.ssh/agent/s.lHgXVr00zz.agent.xqlR0kssWW
set -gx ZED_DEVICE_ID 0x10de

# Path additions (add your custom paths here)
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# ============================================
# Tool Configurations
# ============================================

# fzf configuration
if type -q fzf
    set -gx FZF_PREVIEW_DIR_CMD eza --all --color=always
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --margin=1 --padding=1'
    set -gx FZF_PREVIEW_COMMAND "bat --color=always --line-range :500 {}"
end

# bat configuration
if type -q bat
    set -gx BAT_THEME "Catppuccin Mocha"
    set -gx BAT_STYLE "numbers,changes,header"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# ============================================
# Aliases
# ============================================

# Flatpak aliases
if type -q flatpak
    alias fpk='flatpak'
    alias fpki='flatpak install'
    alias fpkr='flatpak uninstall'
    alias fpks='flatpak search'
    alias fpku='flatpak update'
    alias fpkl='flatpak list'
    alias fpkrun='flatpak run'
end

# eza (ls replacement)
if type -q eza
    alias ls='eza --icons --group-directories-first'
    alias la='eza --icons --group-directories-first -a'
    alias ll='eza --icons --group-directories-first -l --git'
    alias lla='eza --icons --group-directories-first -la --git'
    alias lt='eza --icons --group-directories-first --tree --level=2'
    alias lta='eza --icons --group-directories-first --tree --level=2 -a'
    alias tree='eza --tree --icons'
end

# bat (cat replacement)
if type -q bat
    alias cat='bat --paging=never'
    alias catp='bat' # with paging
    alias less='bat'
end

# ripgrep
if type -q rg
    alias grep='rg'
end

# Modern alternatives
if type -q btop
    alias top='btop'
    alias htop='btop'
end

if type -q dust
    alias du='dust'
end

if type -q duf
    alias df='duf'
end

if type -q procs
    alias ps='procs'
end

# Common shortcuts
alias restart='exec fish'
alias reload='source ~/.config/fish/config.fish'
alias ..='z ..'
alias ...='z ../..'
alias ....='z ../../..'
alias c='clear'
alias h='history'
alias q='exit'

# System management (Arch)
alias install='paru -S' # 'sudo pacman -S'
alias remove='paru -Rns' # 'sudo pacman -Rns'
alias search='paru -Ss' # 'pacman -Ss'
alias clean='sudo pacman -Sc && paru -Sc'
alias orphans='paru -Rns (paru -Qtdq)' # 'sudo pacman -Rns (pacman -Qtdq)'

# Niri shortcuts
alias niri-reload='niri msg action reload-config'
alias niri-validate='niri validate'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# System info
if type -q fastfetch
    alias ff='fastfetch'
    alias fetch='fastfetch'
end

# ============================================
# Functions
# ============================================

# Quick directory navigation with fzf
function fcd
    set -l dir (fd --type d --hidden --follow --exclude .git | fzf --prompt="Directory: " --preview='eza --tree --level=1 --icons {}')
    and cd $dir
end

# Search and edit file with fzf and ripgrep
function fe
    set -l file (rg --files --hidden --follow --glob '!.git' | fzf --prompt="Edit: " --preview='bat --color=always --style=numbers --line-range=:500 {}')
    and $EDITOR $file
end

# Interactive ripgrep with fzf
function rgf
    rg --color=always --line-number --no-heading --smart-case "$argv" |
        fzf --ansi --delimiter ':' \
            --preview 'bat --color=always --highlight-line {2} {1}' \
            --preview-window '+{2}/2' \
            --bind 'enter:execute($EDITOR +{2} {1})'
end

# Better history search
function fh
    history | fzf --tac --no-sort | read -l cmd
    and commandline -r $cmd
end

# Create directory and cd into it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Extract archives
function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Flatpak search and install with fzf
function fpkf
    set -l app (flatpak remote-ls --app | fzf --header="Select app to install" | awk '{print $2}')
    and flatpak install -y $app
end

# Clean unused flatpak runtimes
function fpkclean
    echo "🧹 Cleaning unused Flatpak runtimes..."
    flatpak uninstall --unused -y
    internal_complete "Flatpak cleanup is"
end

# Pacman/AUR package info
function pkginfo
    if pacman -Qi $argv[1] &>/dev/null
        pacman -Qi $argv[1]
    else if pacman -Si $argv[1] &>/dev/null
        pacman -Si $argv[1]
    else
        paru -Si $argv[1]
    end
end

# List explicitly installed packages
function pkglist
    pacman -Qe
end

# ============================================
# Startup
# ============================================

if status is-interactive
    if type -q fzf
        fzf --fish | source
    end

    # Show system info on new terminal
    if type -q fastfetch
        fastfetch
    end

    # Initialize zoxide
    if type -q zoxide
        zoxide init fish | source
    end

    # Node version manager
    if type -q nvm
        nvm -s use 25 2>/dev/null
        or nvm -s use default 2>/dev/null
    end

    if type -q tldr
        # Update tldr cache once per day
        set -l tldr_flag ~/.config/fish/.tldr_updated
        if not test -f $tldr_flag
            or test (find $tldr_flag -mtime +1 2>/dev/null)
            tldr --update 2>/dev/null
            and touch $tldr_flag
        end
    end

    # Starship prompt (must be at end of config)
    if type -q starship
        starship init fish | source
    end
end
