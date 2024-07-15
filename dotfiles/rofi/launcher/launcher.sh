#!/nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash

## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10
## style-11    style-12    style-13    style-14    style-15

dir="$HOME/nixos/dotfiles/rofi/launcher"
theme='style-9'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
