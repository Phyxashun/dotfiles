function zed
    command zeditor $argv &
    sleep 0.6
    niri msg action set-column-width "-1%"
    sleep 0.3
    niri msg action set-column-width "+1%"
end