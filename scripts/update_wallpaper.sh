#!/usr/bin/env bash

#generate random colorscheme and restart dunst
# wal -q -i /home/maksi/Pictures/Wallpapers/ 

wal=$(ls "$HOME/Pictures/Wallpapers/" | shuf -n 1)

# wpg -ns $HOME/Pictures/Wallpapers/$wal

wallust run "$HOME/Pictures/Wallpapers/$wal"

source "$HOME/.cache/wallust/colors.sh"

# ~/nixos/scripts/pywal16.sh

swww img $wallpaper -t center #--transition-step 20 --transition-fps 20 -t center

cp ~/.cache/wallust/gtk-colors.css ~/.config/gtk-3.0/
cp ~/.cache/wallust/gtk-colors.css ~/.config/gtk-4.0/

pkill rofi
makoctl reload

notify-send "Theme and wallpaper updated" "With image $wal"

echo "DONE!"
