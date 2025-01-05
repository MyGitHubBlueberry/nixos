#!/usr/bin/env bash

wallpaper=""
temp="$HOME/Pictures/Wallpapers/temp-wal.jpg"
session=$(loginctl show-session "$(awk '/tty/ {print $1}' <(loginctl))" -p Type | awk -F= '{print $2}')

echo "first arg is $1"
echo "second arg is $2"
echo "third arg is $3"
echo "wallpaper is $wallpaper"

get_wallpaper() {
    case $1 in
        "keep")
            echo "$temp"
            ;;
        *)
            echo "$HOME/Pictures/Wallpapers/$(ls "$HOME/Pictures/Wallpapers/" | shuf -n 1)"
            ;;
    esac

    source "$HOME/.cache/wallust/colors.sh"
}

change_mode() {
    case $1 in
        "light")
            wallust -d ~/nixos/dotfiles/wallust -b full "$wallpaper" --threshold 11 -p light16 -c labmixed
            ;;
        *)
            wallust run "$wallpaper"
            # wallust -d ~/nixos/dotfiles/wallust -b full "$wallpaper" -p dark16 #we use6 this because home-manager doesn't wanna update template folder
            ;;
        # *)
            # current_mode=$(eww get current_mode)
            # change_mode "$current_mode"
            # ;;
    esac    
}

restart() {
    if [[ "$session" = "x11" ]]; then
        rm -f "$temp"
        cp "$wallpaper" "$temp"
        feh --bg-fill "$wallpaper"
        pkill dunst
        xrdb ~/.Xresources
        i3-msg reload
    else
        swww img "$wallpaper" -t center #--transition-step 20 --transition-fps 20 -t center
        makoctl reload
    fi
    pkill rofi
}

wallpaper=$(get_wallpaper "$1")
change_mode "$2"
restart

notify-send "Theme and wallpaper updated" "With image $(basename "$wallpaper")"
