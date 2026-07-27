{ lib, pkgs, ... }:

{
    options.windowManager.enable = lib.mkEnableOption "enable window manager";
    imports = [
        ./hyprland.nix
        ./i3.nix
        ./sleep.nix
    ];

    config = {
        environment.systemPackages = with pkgs; [
            xmodmap             # keyboard remapping
            ssh-askpass-fullscreen # verification for system update
            jq
            pamixer             # for eww
            brightnessctl
        ];
        #for thunar
        services.gvfs.enable = true; # Mount, trash, and other functionalities
        services.tumbler.enable = true; # Thumbnail support for images
        programs.gpu-screen-recorder.enable = true; # for caelestia shell
    };
}
