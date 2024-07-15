#!/usr/bin/env bash

# initialize wallpaper daemon
swww init &
# setting wallpaper
bash ~/Documents/update_wallpaper.sh &

#adding the waybar
waybar &

mako
