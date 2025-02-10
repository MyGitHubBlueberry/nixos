#!/usr/bin/env bash

# initialize wallpaper daemon
swww init &
# setting wallpaper
bash ~/Documents/update_wallpaper.sh &

eww open bar &

hyprctl setcursor Bibata-Modern-Classic 16

mako
