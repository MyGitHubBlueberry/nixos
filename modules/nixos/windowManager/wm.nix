{ lib, config, pkgs, ... }:

{
    options.windowManager.enable = lib.mkEnableOption "enable window manager";
    imports = [
        ./hyprland.nix
        ./i3.nix
        ./sleep.nix
    ];
    config = {
        environment.systemPackages = with pkgs; [
            eww
            xorg.xmodmap #for switching right alt
            rofi-wayland #app access
            xfce.thunar #file manager
            xfce.xfce4-settings
            pavucontrol #audio settings
            pulseaudioFull
            wallust #for pretty colors
            swappy #for viewing pictures
            ssh-askpass-fullscreen #verification for system update
            jq #for scripts and eww
            pamixer #for and eww
            gnome-control-center #for and eww
            gnome-clocks
            gnome-calculator
            gnome-calendar
        ];
#for thunar
        services.gvfs.enable = true; # Mount, trash, and other functionalities
        services.tumbler.enable = true; # Thumbnail support for images
    };

}
