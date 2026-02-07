journalctl -S now -f -u systemd-logind | while read -r line; do
    if echo "$line" | grep -iq "Lid opened"; then
        echo "LID opened at $(date)"
        autorandr -l dualScreen
        eww open bar --screen=1
    elif echo "$line" | grep -iq "Lid closed"; then
        echo "LID closed at $(date)"
        autorandr -l docked
        eww close bar
    fi
done
