{ lib, config, ... }:
let
  templatesDir = ../../dotfiles/wallust/templates;
in
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
                    src = "${templatesDir}/colors-hyprland.conf";
                    dst = "/etc/nixos/modules/home-manager/colors-hyprland.conf";
                    pywal = true;
                };
            }

            (lib.mkIf (!config.caelestia.enable) {
             colors = {
                 src = "${templatesDir}/colors.sh";
                 dst = "~/.cache/wallust/colors.sh";
                 pywal = true; 
             };
             kitty = {
                 src = "${templatesDir}/colors-kitty.conf";
                 dst = "~/.cache/wallust/colors-kitty.conf";
                 pywal = true;
             };
             rofi = {
                 src = "${templatesDir}/colors-rofi.rasi";
                 dst = "/etc/nixos/dotfiles/rofi/colors.rasi";
                 pywal = false;
             };
             xresources = {
                 src = "${templatesDir}/colors.Xresources";
                 dst = "~/.cache/wallust/colors.Xresources";
                 pywal = true;
             };
             scss = {
                 src = "${templatesDir}/colors.scss";
                 dst = "~/.config/eww/scripts/colors/my_colors.scss";
                 pywal = true;
             };
             eww = {
                 src = "${templatesDir}/eww-template.scss";
                 dst = "~/.config/eww/scripts/colors/template.scss";
                 pywal = true;
             };
            })
            (lib.mkIf (config.mako.enable) {
                 mako = {
                     src = "${templatesDir}/mako";
                     dst = "~/.config/mako/config";
                     pywal = true;
                 };
            })
            (lib.mkIf (config.dunst.enable) {
                 dunst = {
                     src = "${templatesDir}/dunst";
                     dst = "~/.config/dunst/dunstrc";
                     pywal = true;
                 };
            })
            ];
        };
    };
}
