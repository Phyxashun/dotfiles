# Initial setup of necessary apps
function initial-setup
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
