#!/usr/bin/env bash

# initialize wallpaper daemon
awww-daemon &
awww restore &
# setting wallpaper
bash ./update_wallpaper.sh &

bash ./set_kb_layouts.sh &
eww open bar &

hyprctl setcursor Bibata-Modern-Classic 16

mako
