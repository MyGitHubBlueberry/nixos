#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"

RANDOM_IMAGE=$(find "$WALL_DIR" -type f | shuf -n 1)
if [ -n "$RANDOM_IMAGE" ]; then
    caelestia wallpaper -f "$RANDOM_IMAGE"
    wallust run --backend=wal --colorspace=lab --palette=dark "$RANDOM_IMAGE"
fi
