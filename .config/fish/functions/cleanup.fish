# Quick system cleanup
function cleanup
    header "🧹 Cleaning package cache..." -e
    cecho cyan bold "\n📦 PACMAN..."
    sudo pacman -Sc --noconfirm
    cecho cyan bold "\n📦 PARU..."
    paru -Sc --noconfirm
    echo

    set orphans (pacman -Qtdq)
    if test -n "$orphans"
        header "🧹 Removing orphaned packages..." -e
        echo
        set_color cyan
        sudo pacman -Rns --noconfirm $orphans
        set_color normal
    else
        cecho yellow "✓ No orphaned packages found"

    end

    if type -q flatpak
        header "🧹 Cleaning Flatpak..." -e
        set_color cyan
        flatpak uninstall --unused -y
        set_color normal
    end
    echo
    echo
    internal_complete "Cleanup is"
    set_color normal
end

# Display complete
function internal_complete --argument-names text_color task
    test -z "$text_color"; and set text_color green
    test -z "$task"; and set task ""
    cecho $text_color bold "✨ $task Complete! ✨"
end
