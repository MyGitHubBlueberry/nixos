notify_with_progress() {
    local icon_placeholder="none"
    local id_placeholder="none"

    local time=$1
    local app=$2
    local message=$3
    local icon=$4
    local id=$5
    local pid=$6

    local sec_rem=$time


    while [ "$sec_rem" -gt 0 ] && { [ -z "$pid" ] || ps -p $pid > /dev/null; }; do
        # Calculate percentage of time passed 
        elapsed_seconds=$(($time - sec_rem + 1))
        percentage=$(($elapsed_seconds * 100 / $time))

        if [[ "$id" == "$id_placeholder" ]]; then
            if [[ "$icon" == "$icon_placeholder" ]]; then
                id=$(notify-send -h int:value:$percentage -t 1200 "$app" "$message" -p)
            else
                id=$(notify-send -i $icon -h int:value:$percentage -t 1200 "$app" "$message" -p)
            fi
        else
            if [[ "$icon" == "$icon_placeholder" ]]; then
                notify-send -h int:value:$percentage -t 1200 "$app" "$message" -r "$id"
            else
                notify-send -i $icon -h int:value:$percentage -t 1200 "$app" "$message" -r "$id"
            fi
        fi

        sleep 1
        sec_rem=$((sec_rem - 1))
    done

    echo $id
}
