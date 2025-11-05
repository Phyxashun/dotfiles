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
    if not type -q paru
        header "📦 Installing paru (AUR helper)..."
        echo
        sudo pacman -S --noconfirm git base-devel rustup
        cd /tmp
        git clone https://aur.archlinux.org/paru.git
        cd paru
        rustup default stable
        makepkg -si --noconfirm
        cd ~
        rm -rf /tmp/paru
    end

    mkdir -p ~/.config/fish/functions
    mkdir -p ~/.config/fish/conf.d

    if not functions -q fisher
        header "🎣 Installing Fisher..."
        echo
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        echo
        fisher install jorgebucaran/fisher

        header "🔌 Installing Fisher plugins..."
        echo
        set -l plugins \
            jorgebucaran/autopair.fish \
            jorgebucaran/nvm.fish \
            jethrokuan/z \
            patrickf1/fzf.fish \
            franciscolourenco/done \
            wfxr/forgit \
            decors/fish-colored-man \
            edc/bass \
            oh-my-fish/plugin-bang-bang \
            jhillyerd/plugin-git \
            nickeb96/puffer-fish

        for plugin in $plugins
            fisher install $plugin 2>/dev/null
            or echo "✓ $plugin already installed"
        end
    end

    set -l tools \
        eza \
        bat \
        ripgrep \
        fd \
        fzf \
        zoxide \
        starship \
        fastfetch \
        neovim \
        tmux \
        git \
        github-cli \
        less \
        lazygit \
        flatpak \
        fwupd \
        curl \
        wget \
        jq \
        btop \
        dust \
        duf \
        procs \
        sd \
        tokei \
        cmatrix \
        figlet \
        toilet \
        toilet-fonts \
        catimg \
        jp2a \
        hyperfine \
        tealdeer

    for tool in $tools
        if not pacman -Qi $tool &>/dev/null
            header "📦 Installing $tool..."
            echo
            #sudo pacman -S --noconfirm $tool
            paru -S --noconfirm $tool
            echo
        end
    end

    if type -q flatpak; and not flatpak remotes | grep -q flathub
        header "📦 Adding Flathub repository..."
        echo
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    end

    sudo ln -sf /usr/share/figlet /usr/share/toilet 2>/dev/null

    touch $SETUP_FLAG
    echo
    echo
    echo "✨ Setup complete! Restart your shell."
    echo
    exit
end

# ============================================
# Environment Variables
# ============================================
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
set SSH_AUTH_SOCK /home/phyxashun/.ssh/agent/s.lHgXVr00zz.agent.xqlR0kssWW

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

function setup_git
    git config --global user.name "Dustin Dew"
    git config --global user.email "phyxashun@gmail.com"
    git config --global init.defaultBranch "main"
    git config --global color.ui "true"
    git config --global core.editor "code"
    git config --list
    echo
    cecho GREEN BOLD " git has been configured..."
end

# You can switch frame to "▒", "▓", "█", "#", "*", etc.
set -g frame_char "░"

# Pad message to ensure max_frame_length characters long
function pad_message --argument-names message max_frame_length pad_char
    set message (string join " " $message)
    test -z "$pad_char"; and set pad_char " "
    
    set -l max_length (math "$max_frame_length - 2")
    if test (string length $message) -gt $max_length
        set message (string sub -l $max_length -- $message)
    end
    string pad --center --char $pad_char --width $max_length "$message"
end

# Create a header with full background color and separate frame/text colors
function header --argument-names message frame_color text_color bg_color
    # Set defaults
    test -z "$frame_color"; and set frame_color yellow
    test -z "$text_color"; and set text_color white
    test -z "$bg_color"; and set bg_color black
    
    # Get terminal width once
    set -l max_frame_length (math (tput cols) - 2)
    
    # Pre-compute frame elements
    set -l divider (string repeat -n $max_frame_length $frame_char)
    set -l empty_divider "$frame_char"(pad_message " " $max_frame_length)"$frame_char"
    set -l padded_message (pad_message "$message" $max_frame_length)
    
    echo
    cecho -b $bg_color $frame_color --bold "$divider"
    cecho -b $bg_color $frame_color --bold "$empty_divider"
    cecho -n -b $bg_color $frame_color --bold "$frame_char"
    cecho -n -b $bg_color $text_color --bold "$padded_message"
    cecho -b $bg_color $frame_color --bold "$frame_char"
    cecho -b $bg_color $frame_color --bold "$empty_divider"
    cecho -b $bg_color $frame_color --bold "$divider"
    echo
end

# Color echo function with enhanced multi-style support
function cecho
    set -l fg_color normal
    set -l bg_color normal
    set -l style_args
    set -l message_parts
    set -l no_newline false
    set -l skip_next 0
    set -l color_set false
    set -l collecting_message false
    
    for i in (seq (count $argv))
        if test $skip_next -eq 1
            set skip_next 0
            continue
        end
        set -l arg $argv[$i]
        set -l upper_arg (string upper -- $arg)
        
        # Once we start collecting message parts, everything goes into message
        if test "$collecting_message" = true
            set -a message_parts $arg
            continue
        end
        
        switch $arg
            case -n
                set no_newline true
            case -b
                if test (count $argv) -ge (math $i + 1)
                    set bg_color $argv[(math $i + 1)]
                    set skip_next 1
                end
            case --bold --underline --dim --italics
                set -a style_args $arg
            case '*'
                # Check if this is a recognized color/style keyword
                switch $upper_arg
                    case BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE
                        if test "$color_set" = false
                            set fg_color (string lower -- $upper_arg)
                            set color_set true
                        else
                            # If color already set, this starts the message
                            set -a message_parts $arg
                            set collecting_message true
                        end
                    case BOLD
                        set -a style_args --bold
                    case UNDERLINE
                        set -a style_args --underline
                    case DIM
                        set -a style_args --dim
                    case ITALICS
                        set -a style_args --italics
                    case NC NORMAL RESET
                        # These don't do anything but don't start the message either
                    case '*'
                        # Not a recognized keyword, must be message
                        set -a message_parts $arg
                        set collecting_message true
                end
        end
    end
    
    set -l message (string join " " $message_parts)
    
    # Apply colors and styles
    test "$bg_color" != normal; and set_color -b $bg_color
    
    if test (count $style_args) -gt 0
        set_color $style_args $fg_color
    else
        set_color $fg_color
    end
    
    # Print and reset
    printf "%b" "$message"
    set_color normal
    test "$no_newline" = false; and echo
end

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

# Quick system cleanup
function cleanup
    header "🧹 Cleaning package cache..."
    cecho cyan bold "\n📦 PACMAN..."
    sudo pacman -Sc --noconfirm
    cecho cyan bold "\n📦 PARU..."
    paru -Sc --noconfirm
    echo

    set orphans (pacman -Qtdq)
    if test -n "$orphans"
        header "🧹 Removing orphaned packages..."
        echo
        set_color cyan
        sudo pacman -Rns --noconfirm $orphans
        set_color normal
    else
        cecho yellow "✓ No orphaned packages found"
  
    end
    
    if type -q flatpak
        header "🧹 Cleaning Flatpak..."
        set_color cyan
        flatpak uninstall --unused -y
        set_color normal
    end
    echo
    echo
    internal_complete "Cleanup is"
    set_color normal
end

# Update Paru
function update_paru
    if type -q paru
        header "🔄 Updating system packages..."
        echo
        paru -Syu --noconfirm
    end
end

# Update Flatpak
function update_flatpak
    if type -q flatpak
        header "📦 Updating Flatpak apps..."
        echo
        flatpak update -y
    end
end

# Firmware Update
function update_firmware
    echo
    if not type -q fwupdmgr
        echo "fwupd not installed. Install with: paru -S fwupd"
        return 1
    end
    header "💾 Checking for firmware updates..."
    fwupdmgr refresh --force
    echo
    fwupdmgr get-updates
    echo
    read -P "Apply firmware updates? [y/N] " -l confirm
    echo
    if test "$confirm" = y -o "$confirm" = Y
        fwupdmgr update
    end
    echo
    internal_complete "Firware update is"
end

# Internal Firmware Update
function update_internal_firmware
    if type -q fwupdmgr
        header "💾 Checking for firmware updates..."
        echo
        fwupdmgr refresh --force 2>/dev/null && echo
        and fwupdmgr update -y 2>/dev/null && echo
        or echo "No firmware updates available"
    end
end

# Update Fisher Plugins
function update_fisher
    if type -q fisher
        header "🔌 Updating Fisher plugins..."
        echo
        fisher update
    end
end

# Update TLDR Cache
function update_tldr
    if type -q tldr
        header "📚 Updating tldr cache..."
        echo
        tldr --update
    end
end

# Update the entire system
function update
    echo
    update_paru
    echo
    update_flatpak
    echo
    update_internal_firmware
    echo
    update_fisher
    echo
    update_tldr
    echo
    echo
    header "🚀 System Update Complete!" blue white
end

# Reset Fish Setup
function reset-setup
    rm -f ~/.config/fish/.setup_complete
    cecho -n yellow --bold "\n    "
    cecho -n red --bold --underline "Setup flag cleared. Restart fish to reinstall."
    cecho yellow --bold "    "
end

# Display complete
function internal_complete --argument-names text_color task
    test -z "$text_color"; and set text_color green
    test -z "$task"; and set task ""
    cecho $text_color --bold "✨ $task Complete! ✨"
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
