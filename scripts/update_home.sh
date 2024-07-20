#!/usr/bin/env bash

check_for_updates() {
# Get the hash of the current configuration
current_hash=$(home-manager generations | head -n 1 | awk '{print $1}')

# Get the hash of the desired configuration from your flake
desired_hash=$(nix flake show $HOME/nixos | grep home-manager | awk '{print $2}')

# Compare the current hash with the desired hash
if [ "$current_hash" != "$desired_hash" ]; then
    echo "Performing home-manager switch..."
else
    echo "No changes detected. No need to perform home-manager switch."
fi
}

approximate_update_time() {
    # Get the number of packages being updated
    num_packages=$(nix-store -q --requisites $(which home-manager) | wc -l)
    echo "Num packages: $num_packages"

    # Get the average time per package update (you can adjust this based on your system)
    avg_time_per_package=5

    # Estimated time for package updates
    total_time=$((num_packages * avg_time_per_package))

    # Additional time for configuration changes, system performance, etc.
    additional_time=60

    # Estimated total time for home-manager switch
    estimated_time=$((total_time + additional_time))

    echo "Estimated time for home-manager switch: $estimated_time seconds"
}

countdown() {
    if [ "$#" -lt 1 ]; then
        echo "Incorrect usage! Example:"
        echo 'countdown.sh <icon>'
        exit 1
    fi

    icon="$1"
    notification_id="-1"
    # estimated_time=10 #delete it

    sec_rem=$estimated_time

    while ps -p $update_pid > /dev/null && [ "$sec_rem" -gt 0 ]; do

        # Calculate percentage of estimated_time passed
        elapsed_seconds=$((estimated_time - sec_rem + 1))
        percentage=$((elapsed_seconds * 100 / estimated_time))
        if [[ "$notification_id" == "-1" ]]; then
            notification_id=$(notify-send -i $icon -h int:value:$percentage -t 1200 "Home-manager" "Evaluating your derivation..." -p)
        else
            notify-send -i $icon -h int:value:$percentage -t 1200 "Home-manager" "Updating..." -r "$notification_id" 
        fi

        sleep 1
        sec_rem=$((sec_rem - 1))
    done

    if [[ "$sec_rem" = 0 ]]; then
        notify-send -i $icon "Home-manager" "Working on updates..." -r "$notification_id" 
    fi

}

check_for_updates

# Run the command in the background and capture the output
home_manager_msg=$(home-manager switch --flake $HOME/nixos 2>&1 > /tmp/home_manager_output) &
update_pid=$!

approximate_update_time

icon="$HOME/Pictures/Icons/home-manager.svg"
countdown $icon

wait $update_pid

home_manager_msg=$(cat /tmp/home_manager_output)

if [[  -n "$(echo "$home_manager_msg" | grep "Creating profile")" ]]; then
    notify-send -i $icon "Home-manager" "Updated successfully" -r "$notification_id" 
elif [[ -n "$(echo "$home_manager_msg" | grep "No change")" ]]; then
    notify-send -i $icon "Home-manager" "No changes detected" -r "$notification_id" 
else
    notify-send -u critical -i $icon "Home-manager" "Error trying to update" -r "$notification_id" 
fi

echo $home_manager_msg


