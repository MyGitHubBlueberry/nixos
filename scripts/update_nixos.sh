source "$(dirname "$0")/notification_functions.sh"
export SUDO_ASKPASS=$(which ssh-askpass-fullscreen)

icon="$HOME/Pictures/Icons/nix.svg"
app="NixOS"
preupdate_time=10
update_time=10
raw_message=$(sudo -A nixos-rebuild switch --flake "$HOME"/nixos > /tmp/nixos_output 2>&1) &
pid=$!

id=$(notify_with_progress_untill_time_is_up $preupdate_time $app "Evaluating your derivation..." "$icon" "" $pid)
notify_with_progress_until_process_done $update_time $app "Working on updates..." "$icon" "$id" $pid

raw_message=$(cat /tmp/nixos_output)

if [[  -n "$(echo "$raw_message" | grep "starting the following units: accounts-daemon.service")" ]]; then
    notify-send -i $icon $app "Updated successfully" -r "$id" 
elif [[ -n "$(echo "$raw_message" | grep "error")" ]]; then
    notify-send -u critical -i $icon $app "Error trying to update" -r "$id" 
else
    notify-send -i $icon $app "No changes detected" -r "$id" 
fi
