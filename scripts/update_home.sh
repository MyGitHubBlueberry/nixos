#!/usr/bin/env bash

source "$(dirname "$0")/notification_functions.sh"

main() {
    # Run the command in the background and capture the output
    local home_manager_msg=$(home-manager switch --flake "path:/etc/nixos#$(whoami)@$(hostname)" 2>&1 > /tmp/home_manager_output) &
    pid=$!

    local icon="$HOME/Pictures/Icons/home-manager.svg"
    local app="Home-manager"

    local preupdate_time=3
    local update_time=10

    local id=$(notify_with_progress_untill_time_is_up $preupdate_time $app "Checking home-manager files..." "$icon" "" $pid)
    notify_with_progress_until_process_done $update_time $app "Working on updates..." "$icon" "$id" $pid

    home_manager_msg=$(cat /tmp/home_manager_output)

    if [[  -n "$(echo "$home_manager_msg" | grep "Creating home")" ]]; then
        notify-send -i "$icon" $app "Updated successfully" -r "$id" 
    elif [[ -n "$(echo "$home_manager_msg" | grep "No change")" ]]; then
        notify-send -i "$icon" $app "No changes detected" -r "$id" 
    else
        notify-send -u critical -i "$icon" $app "Error trying to update" -r "$id" 
    fi

    echo $home_manager_msg
}

# approximate_update_time() {
#     # Get the number of packages being updated (in fact just installed)
#     local num_packages=$(nix-store -q --requisites $(which home-manager) | wc -l)
#
#     # Get the average time per package update (you can adjust this based on your system)
#     local avg_time_per_package=1
#
#     # Estimated time for package updates
#     local total_time=$((num_packages * avg_time_per_package))
#
#     # Additional time for configuration changes, system performance, etc.
#     local additional_time=0
#
#     # Estimated total time for home-manager switch
#     local estimated_time=$((total_time + additional_time))
#
#     echo $estimated_time
# }

main
