action=$1    # "focus" or "move"
direction=$2 # "l", "r", "u", "d"

# Get current window info in one go
active_window=$(hyprctl activewindow -j)

# Extract info using jq
is_grouped=$(echo "$active_window" | jq -r '.grouped | length')
addr=$(echo "$active_window" | jq -r '.address')
# Get all window addresses in the current group
group_windows=$(echo "$active_window" | jq -r '.grouped[]')

# -----------------------------------------------------------------------
# LOGIC: NOT IN A GROUP
# -----------------------------------------------------------------------
if [[ "$is_grouped" == "0" || "$is_grouped" == "null" ]]; then
    if [[ "$action" == "focus" ]]; then
        hyprctl dispatch movefocus "$direction"
    else
        # movewindoworgroup handles dragging windows INTO groups automatically
        hyprctl dispatch movewindoworgroup "$direction"
    fi
    exit 0
fi

# -----------------------------------------------------------------------
# LOGIC: INSIDE A GROUP
# -----------------------------------------------------------------------

# 1. Determine current index and group size
# Convert the list of addresses to an array
group_addrs=($group_windows)
group_len=${#group_addrs[@]}
current_idx=-1

for i in "${!group_addrs[@]}"; do
   if [[ "${group_addrs[$i]}" == "0x${addr#0x}" ]]; then # Handle 0x prefix consistency
       current_idx=$i
       break
   fi
done

# 2. Determine "Internal" Direction (Back vs Forward)
# standard i3/vim: h/k (left/up) = back, l/j (right/down) = forward
if [[ "$direction" == "l" || "$direction" == "u" ]]; then
    target_dir="b"
    at_boundary=$((current_idx == 0))
else
    target_dir="f"
    at_boundary=$((current_idx == group_len - 1))
fi

# 3. Execute Action
if [[ "$action" == "focus" ]]; then
    if [[ "$at_boundary" -eq 1 ]]; then
        # Boundary hit: Focus moves OUT of the group
        hyprctl dispatch movefocus "$direction"
    else
        # Boundary not hit: Focus cycles INSIDE the group
        hyprctl dispatch changegroupactive "$target_dir"
    fi

elif [[ "$action" == "move" ]]; then
    if [[ "$at_boundary" -eq 1 ]]; then
        # FIX: Explicitly detach first, THEN move in the requested direction.
        # This overrides the default layout behavior of placing new windows to the right.
        hyprctl --batch "dispatch moveoutofgroup; dispatch movewindow $direction"
    else
        # Boundary not hit: Swap window position INSIDE the group
        hyprctl dispatch movegroupwindow "$target_dir"
    fi
fi
