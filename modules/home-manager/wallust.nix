{ lib, config, ... }:

{
    options = {
        wallust.enable 
            = lib.mkEnableOption "enable wallust";
    };

    config = lib.mkIf config.wallust.enable {
        programs.wallust.enable = true;
        programs.wallust.settings = {
            backend = "full";
            color_space = "lab";
            threshold = 11;
            palette = "dark16";
            generation = "Complement";
            templates = lib.mkMerge [
            {
                hyprland = {
                    src = "colors-hyprland.conf";
                    dst = "~/nixos/modules/home-manager/colors-hyprland.conf";
                    pywal = true;
                };
            }

            (lib.mkIf (!config.caelestia.enable) {
             colors = {
                 src = "colors.sh";
                 dst = "~/.cache/wallust/colors.sh";
                 pywal = true; 
             };
             kitty = {
                 src = "colors-kitty.conf";
                 dst = "~/.config/kitty/kitty.conf";
                 pywal = true;
             };
             rofi = {
                 src = "colors-rofi.rasi";
                 dst = "~/nixos/dotfiles/rofi/colors.rasi";
                 pywal = false;
             };
             xresources = {
                 src = "colors.Xresources";
                 dst = "~/.cache/wallust/colors.Xresources";
                 pywal = true;
             };
             scss = {
                 src = "colors.scss";
                 dst = "~/.config/eww/scripts/colors/my_colors.scss";
                 pywal = true;
             };
             eww = {
                 src = "eww-template.scss";
                 dst = "~/.config/eww/scripts/colors/template.scss";
                 pywal = true;
             };
            })
            (lib.mkIf (config.mako.enable) {
                 mako = {
                     src = "mako";
                     dst = "~/.config/mako/config";
                     pywal = true;
                 };
            })
            (lib.mkIf (config.dunst.enable) {
                 dunst = {
                     src = "dunst";
                     dst = "~/.config/dunst/dunstrc";
                     pywal = true;
                 };
            })
            ];
        };
    };
}
