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
