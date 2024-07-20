#!/usr/bin/env bash

countdown() {
    if [ "$#" -lt 1 ]; then
        echo "Incorrect usage! Example:"
        echo './countdown.sh <duration_in_seconds> <header> <msg> <icon>'
        echo 'use $sec_rem in your display message to display remaining seconds'
        exit 1
    fi

    total_duration="$1"
    header="$2"
    msg="$3"
    icon="$4"
    sec_rem="$total_duration"
    notification_id="-1"

    while [ "$sec_rem" -gt 0 ]; do
        # Calculate percentage of time passed
        elapsed_seconds=$((total_duration - sec_rem + 1))
        percentage=$((elapsed_seconds * 100 / total_duration))

        notification_id=$(notify-send -i $icon -h int:value:$percentage -t 1200 $header $msg -p)

        sleep 1
        sec_rem=$((sec_rem - 1))
    done
}

countdown 10 test "eheheheh" $HOME/Pictures/Icons/home-manager.svg
