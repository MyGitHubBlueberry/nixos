#!/usr/bin/env bash

main() {
    # Run the command in the background and capture the output
    home_manager_msg=$(home-manager switch --flake $HOME/nixos 2>&1 > /tmp/home_manager_output) &
    update_pid=$!

    icon="$HOME/Pictures/Icons/home-manager.svg"

    preupdate_time=3
    update_time=$(approximate_update_time)

    echo $update_time

    id=$(countdown $preupdate_time "Home-manager" "Evaluating your derivation..." $icon)
    echo $id
    countdown $update_time "Home-manager" "Updating..." $icon $id
    # notify-send -i $icon "Home-manager" "Working on updates..." -r "$id" 

    wait $update_pid

    home_manager_msg=$(cat /tmp/home_manager_output)

    if [[  -n "$(echo "$home_manager_msg" | grep "Creating profile")" ]]; then
        notify-send -i $icon "Home-manager" "Updated successfully" -r "$id" 
    elif [[ -n "$(echo "$home_manager_msg" | grep "No change")" ]]; then
        notify-send -i $icon "Home-manager" "No changes detected" -r "$id" 
    else
        notify-send -u critical -i $icon "Home-manager" "Error trying to update" -r "$id" 
    fi

    echo $home_manager_msg
}

approximate_update_time() {
    # Get the number of packages being updated (in fact just installed)
    local num_packages=$(nix-store -q --requisites $(which home-manager) | wc -l)

    # Get the average time per package update (you can adjust this based on your system)
    local avg_time_per_package=1

    # Estimated time for package updates
    local total_time=$((num_packages * avg_time_per_package))

    # Additional time for configuration changes, system performance, etc.
    local additional_time=0

    # Estimated total time for home-manager switch
    local estimated_time=$((total_time + additional_time))

    echo $estimated_time
}

countdown() {
    local impossible_id="-1"

    local time=$1
    local app=$2
    local message=$3
    local icon=$4
    local notification_id=${5:-$impossible_id}

    local sec_rem=$time

    while ps -p $update_pid > /dev/null && [ "$sec_rem" -gt 0 ]; do
        # Calculate percentage of time passed 
        elapsed_seconds=$(($time - sec_rem + 1))
        percentage=$(($elapsed_seconds * 100 / $time))


        if [[ "$notification_id" == "$impossible_id" ]]; then #if you want to ubstruct it, don't forget about $persentage in while loop, you, ididot!
            notification_id=$(notify-send -i $icon -h int:value:$percentage -t 1200 "$app" "$message" -p)
        else
            notify-send -i $icon -h int:value:$percentage -t 1200 "$app" "$message" -r "$notification_id" 
        fi

        sleep 1
        sec_rem=$((sec_rem - 1))
    done

    echo $notification_id
}


main
