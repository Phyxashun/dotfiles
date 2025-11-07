# Update Paru
function update_paru
    if type -q paru
        header "🔄 Updating system packages..." -e
        echo
        paru -Syu --noconfirm
    end
end

# Update Flatpak
function update_flatpak
    if type -q flatpak
        header "📦 Updating Flatpak apps..." -e
        echo
        flatpak update -y
    end
end

# Firmware Update
function update_firmware
    if type -q fwupdmgr
        header "💾 Checking for firmware updates..." -e
        echo
        fwupdmgr refresh --force 2>/dev/null && echo
        and fwupdmgr update -y 2>/dev/null && echo
        or echo "No firmware updates available"
    end
end

# Update Fisher Plugins
function update_fisher
    if type -q fisher
        header "🔌 Updating Fisher plugins..." -e
        echo
        fisher update
    end
end

# Update TLDR Cache
function update_tldr
    if type -q tldr
        header "📚 Updating tldr cache..." -e
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
    update_firmware
    echo
    update_fisher
    echo
    update_tldr
    echo
    echo
    header "🚀 System Update Complete!" blue white -e
end
