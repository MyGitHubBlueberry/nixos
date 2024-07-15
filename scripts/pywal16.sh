#!/usr/bin/env bash

source "$HOME/.cache/wallust/colors.sh"

~/nixos/packages/pywal-sixteen/result/bin/wal -i $wallpaper -s --cols16




mkdir -p ~/.config/presets/user
cp ~/.cache/wal/colors-gradience.json ~/.config/presets/user/colors-gradience.json

gradience-cli apply -n pywal



mkdir -p "${HOME}"/.config/Kvantum/pywal
cp "${HOME}"/.cache/wal/colors-kvantum.kvconfig "${HOME}"/.config/Kvantum/pywal/pywal.kvconfig
cp "${HOME}"/.cache/wal/colors-kvantum.svg "${HOME}"/.config/Kvantum/pywal/pywal.svg

kvantummanager --set "pywal"
