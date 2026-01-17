#!/usr/bin/env fish
# update.fish — single-sudo, safe Arch system update workflow for fish shell
# Usage:
#   update            # quiet mode (minimal output)
#   update -v|--verbose  # verbose: show full command output

# Global verbose flag
set -g __UPDATE_VERBOSE 0

# Parse args (very small parser)
function __parse_args
    for arg in $argv
        switch $arg
            case -v --verbose
                set -g __UPDATE_VERBOSE 1
            case '*'
                # ignore unknown args for now
        end
    end
end

# Helper: run a command with optional verbose output
# Usage: run_cmd <command...>
# Returns: exit code of the command
function run_cmd
    set -l tmp (mktemp)

    if test "$UPDATE_VERBOSE" = 1
        echo -e "\n+ $argv"
    end

    # Run the command safely
    eval $argv >$tmp 2>&1
    set -l code $status

    if test $code -ne 0
        echo "❌ Command failed with exit code $code — output:"
        cat $tmp
    end

    rm -rfv $tmp
    return $code >/dev/null 2>&1
end

# Small helper to prefer AUR helper detection
function detect_aur_helper
    if type -q paru
        echo paru
        return 0
    else if type -q yay
        echo yay
        return 0
    else
        return 1
    end
end

# Sudo keepalive PID holder (global)
set -g sudo_keepalive_pid ''

# Start sudo validation and keepalive
function perform_root
    header "🔒 Requesting sudo to update the system... " -e
    echo
    echo "🦸 This operation requires sudo privileges."

    # Force fresh password prompt
    sudo -k

    # Ask for sudo once
    if not sudo -v
        echo "❌ Error: sudo authentication failed or was cancelled."
        return 1
    end

    # Start keepalive -- refresh timestamp every 60s (non-interactive)
    sh -c "while true; do sleep 60; sudo -vn >/dev/null 2>&1 || exit; done" &
    set -g sudo_keepalive_pid $last_pid

    if test $__UPDATE_VERBOSE -eq 1
        echo "🔧 sudo keepalive pid: $sudo_keepalive_pid"
    end

    echo "✅ Sudo validated. Running updates with a single password prompt."
    return 0
end

# Stop keepalive if running
function stop_root_keepalive
    if set -q sudo_keepalive_pid
        if test -n "$sudo_keepalive_pid"
            and kill $sudo_keepalive_pid >/dev/null 2>&1
            or true
            set -e sudo_keepalive_pid
        end
    end
end

# update packages (pacman + AUR helper)
function update_packages
    header "🔄 Updating Pacman and (AUR)..." -e
    echo

    # Pacman system upgrade
    run_cmd "sudo pacman -Syu --noconfirm"
    or begin
        echo "❌ pacman update failed."
        return 1
    end

    echo "✅ pacman up-to-date."

    # AUR helper if present (prefer paru then yay)
    set -l aur (detect_aur_helper)
    if test -n "$aur"
        echo "ℹ️ Detected AUR helper: $aur"
        run_cmd "$aur -Syu --noconfirm"
        or begin
            echo "❌ $aur update failed."
            return 1
        end
        echo "✅ $aur / AUR up-to-date."
    else
        echo "ℹ️ No AUR helper (paru/yay) found; skipping AUR updates."
    end

    return 0
end

# Flatpak updater
function update_flatpak
    if not type -q flatpak
        echo "ℹ️ Flatpak not installed; skipping."
        return 0
    end

    header "📦 Updating Flatpak apps..." -e
    echo

    # flatpak returns 0 on success (including no-op). 1 = failure.
    run_cmd "flatpak update -y"
    set -l ec $status
    if test $ec -eq 0
        echo "✅ Flatpak updated (or no updates available)."
        return 0
    else
        echo "❌ Flatpak update failed (exit $ec)."
        return $ec
    end
end

# Firmware via fwupdmgr
function update_firmware
    if not type -q fwupdmgr
        echo "ℹ️ fwupdmgr not installed; skipping firmware updates."
        return 0
    end

    header "💾 Checking/updating firmware (fwupdmgr)..." -e
    echo

    # Refresh metadata
    sudo fwupdmgr refresh --force >/dev/null
    set refresh_status $status

    switch $refresh_status
        case 0 2
            # OK — 0 = success, 2 = no updates available
            echo "ℹ️ Firmware metadata refreshed."
        case '*'
            echo "❌ fwupdmgr refresh failed (exit code $refresh_status)."
            return 1
    end

    # Perform updates
    sudo fwupdmgr update -y >/dev/null
    set update_status $status

    switch $update_status
        case 0
            echo "✅ Firmware updated."
        case 2
            echo "ℹ️ No firmware updates available."
        case '*'
            echo "❌ Firmware update failed (exit code $update_status)."
            return 1
    end

    return 0
end

# Fisher plugin updates
function update_fisher
    if not type -q fisher
        echo "ℹ️ fisher not installed; skipping."
        return 0
    end

    header "🔌 Updating Fisher plugins..." -e
    echo

    run_cmd "fisher update"
    if test $status -ne 0
        echo "❌ fisher update failed."
        return 1
    end

    echo "✅ fisher plugins updated."
    return 0
end

# tldr update
function update_tldr
    if not type -q tldr
        echo "ℹ️ tldr not installed; skipping."
        return 0
    end

    header "📚 Updating tldr cache..." -e
    echo

    run_cmd "tldr --update"
    if test $status -ne 0
        echo "❌ tldr update failed."
        return 1
    end

    echo "✅ tldr cache updated."
    return 0
end

# Top-level update orchestration
function update
    # parse args
    __parse_args $argv

    echo
    if not perform_root
        echo "❌ Aborting update due to sudo failure."
        stop_root_keepalive
        return 1
    end

    # Ensure keepalive is cleaned if the script aborts early
    # Fish supports trap: we install a simple EXIT trap that will run stop_root_keepalive
    # when the interactive shell exits or the function returns.
    trap stop_root_keepalive EXIT

    set -l failures 0

    if not update_packages
        echo "⚠️  Packages update failed."
        set failures (math $failures + 1)
    end

    if not update_flatpak
        echo "⚠️  Flatpak update failed."
        set failures (math $failures + 1)
    end

    if not update_firmware
        echo "⚠️  Firmware update failed."
        set failures (math $failures + 1)
    end

    if not update_fisher
        echo "⚠️  Fisher update failed."
        set failures (math $failures + 1)
    end

    if not update_tldr
        echo "⚠️  TLDR update failed."
        set failures (math $failures + 1)
    end

    # cleanup keepalive explicitly and remove trap
    stop_root_keepalive
    echo

    if test $failures -eq 0
        header "🚀 System Update Complete!" blue white -e
    else
        header "⚠️ System Update Completed with $failures issue(s)" yellow white -e
    end

    return 0
end
