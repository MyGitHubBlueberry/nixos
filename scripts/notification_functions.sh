update_args() {
    local arg=$1
    local flag=$2
    local default=$3
    if [ -z "$arg" ]; then
        echo "$default"
        return
    fi
    echo "$flag $arg"
}

update_notification() {
    local app=$1
    local message=$2
    local icon=$3
    local id=$4
    local percentage=$5

    local updated_id
    updated_id=$(update_args "$id" "-r" "-p")
    local updated_icon
    updated_icon=$(update_args "$icon" "-i" "")

    local potential_id
    potential_id=$(notify-send $updated_icon -h int:value:$percentage -t 1200 "$app" "$message" $updated_id)

    if [[ -n $potential_id ]]; then
        id=$potential_id
    fi

    echo "$id"  # Return the updated ID
}

notify_with_progress_until_process_done() {
    local time=$1
    local app=$2
    local message=$3
    local icon=$4
    local id=$5
    local pid=$6

    local sec_rem=$time

    while [ -n "$pid" ] && ps -p $pid > /dev/null; do
        if [[ "$sec_rem" == 0 ]]; then
            sec_rem=$((time / 2 + 1))
        fi  

        local elapsed_seconds=$((time - sec_rem + 1))
        local percentage=$((elapsed_seconds * 100 / time))

        id=$(update_notification "$app" "$message" "$icon" "$id" "$percentage")

        sleep 1
        sec_rem=$((sec_rem - 1))
    done
    echo "$id"
}

notify_with_progress_untill_time_is_up() {
    local time=$1
    local app=$2
    local message=$3
    local icon=$4
    local id=$5
    local pid=$6

    local sec_rem=$time


    while [ "$sec_rem" -gt 0 ] && { [ -z "$pid" ] || ps -p $pid > /dev/null; }; do
        local elapsed_seconds=$((time - sec_rem + 1))
        local percentage=$((elapsed_seconds * 100 / time))

        id=$(update_notification "$app" "$message" "$icon" "$id" "$percentage")

        sleep 1
        sec_rem=$((sec_rem - 1))
    done

    echo $id
}
