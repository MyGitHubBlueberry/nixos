#!/usr/bin/env bash

source "$(dirname "$0")/notification_functions.sh"

main() {
    # Run the command in the background and capture the output
    local home_manager_msg=$(home-manager switch --flake $HOME/nixos 2>&1 > /tmp/home_manager_output) &
    update_pid=$!

    local icon="$HOME/Pictures/Icons/home-manager.svg"

    local preupdate_time=3
    local update_time=$(approximate_update_time)

    local id=$(notify_with_progress $preupdate_time "Home-manager" "Evaluating your derivation..." $icon "none" $update_pid)
    notify_with_progress $update_time "Home-manager" "Updating..." $icon $id $update_pid

    if [[ $(ps -p $update_pid > /dev/null) ]]; then 
        notify-send -i $icon "Home-manager" "Working on updates..." -r "$id" 
    fi

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

main
