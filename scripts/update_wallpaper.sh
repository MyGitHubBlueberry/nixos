#!/usr/bin/env bash

#generate random colorscheme, wallpapers and restart notification-deamon

# wal -q -i /home/maksi/Pictures/Wallpapers/ 

wal=$(ls "$HOME/Pictures/Wallpapers/" | shuf -n 1)
temp="$HOME/Pictures/Wallpapers/temp-wal.jpg"

# wpg -ns $HOME/Pictures/Wallpapers/$wal

# wallust run "$HOME/Pictures/Wallpapers/$wal"
wallust -d ~/nixos/dotfiles/wallust -b full "$HOME/Pictures/Wallpapers/$wal" #we use this because home-manager doesn't wanna update template folder

source "$HOME/.cache/wallust/colors.sh"

# ~/nixos/scripts/pywal16.sh
#
session=$(loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}')

if [[ "$session" = "x11" ]]; then
    feh --bg-fill $wallpaper
    rm $temp
    cp $wallpaper $temp
    pkill dunst
    polybar-msg cmd restart
else
    swww img $wallpaper -t center #--transition-step 20 --transition-fps 20 -t center
    makoctl reload
fi


cp ~/.cache/wallust/gtk-colors.css ~/.config/gtk-3.0/
cp ~/.cache/wallust/gtk-colors.css ~/.config/gtk-4.0/

pkill rofi

# wait 

notify-send "Theme and wallpaper updated" "With image $wal"

echo "DONE!"
echo $session
