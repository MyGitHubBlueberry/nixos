#!/usr/bin/env bash
# wal -q -i /home/maksi/Pictures/Wallpapers/ 

change_mode() {
    case $1 in
        "light")
            wallust -d ~/nixos/dotfiles/wallust -b full "$wallpaper" --threshold 11 -p light16 -c labmixed
            ;;
        "dark")
            # wallust run "$HOME/Pictures/Wallpapers/$wal"
            wallust -d ~/nixos/dotfiles/wallust -b full "$wallpaper" -p dark16 #we use6 this because home-manager doesn't wanna update template folder
            ;;
        *)
            current_mode=$(eww get current_mode)
            change_mode $current_mode
            ;;
    esac    
}

wallpaper=""

case $1 in
    "keep")
        source "$HOME/.cache/wallust/colors.sh"
        ;;
    "change")
        wallpaper="$HOME/Pictures/Wallpapers/$(ls "$HOME/Pictures/Wallpapers/" | shuf -n 1)"
        ;;
    *)
        wallpaper="$HOME/Pictures/Wallpapers/$(ls "$HOME/Pictures/Wallpapers/" | shuf -n 1)"
        ;;
esac

temp="$HOME/Pictures/Wallpapers/temp-wal.jpg"

# wpg -ns $HOME/Pictures/Wallpapers/$wal
change_mode $2

source "$HOME/.cache/wallust/colors.sh"

session=$(loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}')

if [[ "$session" = "x11" ]]; then
    feh --bg-fill $wallpaper
    rm $temp
    cp $wallpaper $temp
    pkill dunst
    xrdb ~/.Xresources
    i3-msg reload
else
    swww img $wallpaper -t center #--transition-step 20 --transition-fps 20 -t center
    makoctl reload
fi

pkill rofi

notify-send "Theme and wallpaper updated" "With image $(basename $wallpaper)"

echo "DONE!"

