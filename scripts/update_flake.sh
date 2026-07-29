source "$(dirname "$0")/notification_functions.sh"

icon="$HOME/Pictures/Icons/flake.svg"
app="Flake"
preupdate_time=3
update_time=10
raw_message=$(nix flake update --flake /etc/nixos > /tmp/flake_output 2>&1) &
pid=$!


id=$(notify_with_progress_untill_time_is_up $preupdate_time $app "Playing with flakes..." "$icon" "" $pid)
notify_with_progress_until_process_done $update_time $app "Working on updates..." "$icon" "$id" $pid

while ps -p $pid > /dev/null; do
    sleep 1
    notify-send -i $icon $app "Working on updates..." -r "$id"
done

raw_message=$(cat /tmp/flake_output)

if [[  -n "$(echo "$raw_message" | grep "Updated")" ]]; then
    notify-send -i $icon $app "Updated successfully" -r "$id" 
elif [[ -n "$(echo "$raw_message" | grep "error")" ]]; then
    notify-send -u critical -i $icon $app "Error trying to update" -r "$id" 
else
    notify-send -i $icon $app "No changes detected" -r "$id" 
fi
