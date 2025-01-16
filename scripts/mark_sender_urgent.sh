#marks application as urgent when it sends notification :)

notification=""

# Start the dbus-monitor in the background
dbus-monitor --session "interface='org.freedesktop.Notifications',member='Notify'" | \
    while read -r line; do
        if [[ "$line" =~ method\ call ]]; then
            # Read the next line containing the string data
            read -r line
            # Extract the notification message and store it in the variable
            notification=$(echo "$line" | sed -n 's/^\s*string "\(.*\)"/\1/p')
            #DO NOT WRAP $notification in "!!!! it STOPS working :)
            wmctrl -r $notification -b add,demands_attention
        fi
    done

# i spent a lot of my presious time on the following function, and 
# it looks like it useless now... big sad :(

# find_window() {
#     local app="$1"
#     local depth="$2"
#
#     local search=".window_properties.class"
#     local prepend=".nodes[]"
#     local nodes;
#     nodes=$(i3-msg -t get_tree | jq '.nodes[] | .nodes[] | .nodes[]')
#
#     # Base case: if depth reaches 0, return nothing
#     if [[ "$depth" -le 0 ]]; then
#         echo "null"
#         return
#     fi
#
#     for ((i = depth; i > 0; i--)); do
#         search=$prepend$search
#         local one='select(.type == "workspace" and '
#         local two=' == $app) | .name'
#         local query=$one$search$two;
#
#         # Iterate through nodes and check if any has the matching class
#         echo "$nodes" | jq -r --arg app "$app" --arg search "$search" \
#             "$query" | {
#             read result
#                     # If we found a match, return the result
#                     if [[ -n "$result" ]]; then
#                         echo "$result"
#                         return
#                     fi
#                 }
#     done
# }
#
# # Start the recursive search from the root nodes, with a depth limit of 3
# find_window "discord" 3
