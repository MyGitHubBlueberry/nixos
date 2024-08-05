#!/nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/nixos/dotfiles/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $HOME/Pictures/Screenshots"

session=$(loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}')
echo $session

if [[ "$theme" == *'type-1'* ]]; then
	list_col='1'
	list_row='5'
	win_width='400px'
elif [[ "$theme" == *'type-3'* ]]; then
	list_col='1'
	list_row='5'
	win_width='120px'
elif [[ "$theme" == *'type-5'* ]]; then
	list_col='1'
	list_row='5'
	win_width='520px'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
	list_col='5'
	list_row='1'
	win_width='670px'
fi

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture Area"
	option_3=" Capture Window"
	option_4=" Capture in 5s"
	option_5=" Capture in 10s"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

countdown() {
    if [ "$#" -lt 1 ]; then
        echo "Incorrect usage! Example:"
        echo './countdown.sh <duration_in_seconds>'
        exit 1
    fi

    local total_duration="$1"
    local sec_rem="$total_duration"
    local notification_id="-1"

    while [ "$sec_rem" -gt 0 ]; do
        # Calculate percentage of time passed
        local elapsed_seconds=$((total_duration - sec_rem + 1))
        local percentage=$((elapsed_seconds * 100 / total_duration))

        if [[ "$notification_id" == "-1" ]]; then
            notification_id=$(notify-send -h int:value:$percentage -t 1200 "Taking shot in: $sec_rem seconds" -p)
        else
            notify-send -h int:value:$percentage -t 1200 "Taking shot in: $sec_rem seconds" -r "$notification_id"
        fi 
        sleep 1
        sec_rem=$((sec_rem - 1))
    done
}

# take shots
shotnow () {
    sleep 0.5 

    if [[ "$session" == "x11" ]]; then
        maim | swappy -f - &
        maim | tee >(swappy -f -) | xclip -selection clipboard -t image/png
    else
        grim - | swappy -f - & 
    fi
    notify-send "Screenshot of whole screen taken"

}

shot5 () {
	countdown '5'
	sleep 1 && shotnow
}

shot10 () {
	countdown '10'
	sleep 1 && shotnow
}

shotwin () {
    # this is for active window only
    # active_window=`hyprctl -j activewindow`
    # box=$(echo $active_window | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    # echo "$box"
    # sleep 0.5 && grim -g "$box" - | swappy -f -
    
    
    if [[ "$session" == "x11" ]]; then
        maim -s -b 3 -c 255,0,0,0 | tee >(swappy -f -) | xclip -selection clipboard -t image/png
    else
        # this is for selected window
        monitors=`hyprctl -j monitors`
        clients=`hyprctl -j clients | jq -r '[.[] | select(.workspace.id | contains('$(echo $monitors | jq -r 'map(.activeWorkspace.id) | join(",")')'))]'`
        boxes="$(echo $clients | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"')"
        box=`slurp -r <<< "$boxes"`
        grim -g "$box" - | swappy -f -
    fi

    notify-send "Screenshot of the window taken"
}

shotarea () {

    if [[ "$session" == "x11" ]]; then
        maim -s -b 3 -c 255,0,0,0 | tee >(swappy -f -) | xclip -selection clipboard -t image/png
    else
        grim -g "$(slurp)" - | swappy -f -
    fi

    notify-send "Screenshot of the region taken"
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac


