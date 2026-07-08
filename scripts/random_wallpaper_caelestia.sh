#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"

RANDOM_IMAGE=$(
    find "$WALL_DIR" \
        -type d -name .git -prune -o \
        -type f -print | shuf -n 1
)

if [ -n "$RANDOM_IMAGE" ]; then
    caelestia wallpaper -f "$RANDOM_IMAGE"
    wallust run \
        --backend=fastresize \
        --colorspace=lab \
        --palette=dark16 \
        --skip-sequences \
        "$RANDOM_IMAGE"
fi
