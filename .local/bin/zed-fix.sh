#!/bin/sh

# Launch Zed and trigger a layout recalculation to fix input handling
WAYLAND_DISPLAY="" zed "$@" &

sleep 0.6

# Resize window slightly and back to force layout recalculation
niri msg action set-column-width "-1%"
sleep 0.3
niri msg action set-column-width "+1%"
