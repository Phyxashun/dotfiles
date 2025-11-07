# Reset Fish Setup
function reset-setup
    rm -f ~/.config/fish/.setup_complete
    cecho -n yellow --bold "\n    "
    cecho -n red --bold --underline "Setup flag cleared. Restart fish to reinstall."
    cecho yellow --bold "    "
end
