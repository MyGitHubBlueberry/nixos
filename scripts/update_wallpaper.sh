#!/usr/bin/env bash

LOCK_FILE="/tmp/update_wallpaper.lock"
wallpaper=""
temp="$HOME/Pictures/Wallpapers/temp-wal.jpg"
session=$(loginctl show-session "$(awk '/tty/ {print $1}' <(loginctl))" -p Type | awk -F= '{print $2}')
cache="$HOME/.cache/eww/preferences.txt"

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
            wallust run -C ~/nixos/dotfiles/wallust/wallust-light.toml "$wallpaper"
            echo "light" > "$cache"
            # eww update current_mode="light"
            ;;
        "dark")
            wallust run "$wallpaper"
            echo "dark" > "$cache"
            # eww update current_mode="dark"
            ;;
        *)
            current_mode=$(eww get current_mode)
            change_mode "$current_mode"
            ;;
    esac
}

restart() {
    if [[ "$session" = "x11" ]]; then
        if [[ "$1" != "keep" ]]; then
            rm -f "$temp"
            cp "$wallpaper" "$temp"
        fi
        feh --bg-fill "$wallpaper"
        pkill dunst
        xrdb ~/.Xresources
        i3-msg reload
    else
        swww img "$wallpaper" -t center #--transition-step 20 --transition-fps 20 -t center
        makoctl reload
    fi
    pkill rofi
    eww update current_mode="$(< "$cache")"
}

# Check if the lock file exists
if [ -e "$LOCK_FILE" ]; then
    echo "Script is already running."
    exit 1
fi

# Create a lock file
touch "$LOCK_FILE"

wallpaper=$(get_wallpaper "$1")
change_mode "$2"
restart "$1"

notify-send "Theme and wallpaper updated" "With image $(basename "$wallpaper")"

# Clean up the lock file upon script exit
trap "rm -f $LOCK_FILE" EXIT

exit 0
