#!/bin/bash

# Workspace 1: SuperCollider + chat + post window
swaymsg workspace 1

# Launch SuperCollider IDE
scide &
sleep 2  # Give it time to spawn both windows

# Move post window out of the way temporarily
swaymsg '[app_id="scide" title="Post window"]' focus

# Split Chromium vertically for the post window
swaymsg splitv

# Launch Chromium kiosk for heckler chat
#chromium-browser --app="https://www.au.dk" &
chromium-browser --password-store=basic --app="http://localhost:5173" &

sleep 1

swaymsg '[title="Heckler"]' move up


swaymsg '[title=".*Peak Clips Meter.*"]' move to workspace 1
swaymsg '[title=".*Peak Clips Meter.*"]' move left
swaymsg '[title=".*Peak Clips Meter.*"]' move left
swaymsg '[title=".*Peak Clips Meter.*"]' resize set width 4 ppt

# Resize main IDE to 2/3 width
swaymsg '[app_id="scide" title="SuperCollider IDE"]' resize set width 65 ppt
swaymsg '[app_id="scide" title="Post window"]' resize set height 33 ppt


sleep 1

# Workspace 2: Reaper
swaymsg workspace 2
reaper &
sleep 2

# Workspace 3: Two terminals
#swaymsg workspace 3
#alacritty &
#sleep 1
#swaymsg splith
#alacritty &
#sleep 1

# Worskpace 4: qpwgraph
swaymsg workspace 4
qpwgraph &

sleep 1

# Return to workspace 1
swaymsg workspace 1
swaymsg '[app_id=".*"]' opacity 0.95
