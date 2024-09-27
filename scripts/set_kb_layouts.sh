#!/usr/bin/env bash
# setxkbmap -layout 'us,ua' -option 'grp:win_space_toggle'
xmodmap -e "keycode 108 = Alt_R Alt_R Alt_R"
