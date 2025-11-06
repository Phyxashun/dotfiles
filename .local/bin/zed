#!/bin/sh

# Launch Zed in the background
zed &

# Wait a moment for the window to appear
sleep 0.5

# Set the window to the desired temporary large width (e.g., 1200 pixels) and a specific height (e.g. 800)
# The --id $(niri msg windows -j | jq -r '.[] | select(.app_id == "zed") | .id') part targets the specific Zed window
# Note: You may need to install 'jq' for this to work
niri msg set-window-width fixed 1200 --id $(niri msg windows -j | jq -r '.[] | select(.app_id == "zed") | .id')
niri msg set-window-height fixed 800 --id $(niri msg windows -j | jq -r '.[] | select(.app_id == "zed") | .id')

# Wait another moment to show the temporary size
sleep 1

# Reset the window height and width back to automatic/default (niri's tiling layout handles this)
niri msg set-window-width --id $(niri msg windows -j | jq -r '.[] | select(.app_id == "zed") | .id')
niri msg set-window-height --id $(niri msg windows -j | jq -r '.[] | select(.app_id == "zed") | .id')
