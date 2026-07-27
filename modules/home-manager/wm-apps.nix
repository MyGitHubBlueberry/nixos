{ lib, config, pkgs, ... }:

{
    options.wmApps.enable = lib.mkEnableOption "common apps for a window manager";

    config = lib.mkIf config.wmApps.enable {
        home.packages = with pkgs; [
            rofi            
            thunar          
            xfce4-settings
            pavucontrol
            pulseaudioFull
            swappy
            gnome-clocks
            gnome-calculator
            gnome-calendar
            gnome-control-center
            eww
        ];
    };
}
