{ config, pkgs, ... }:
{
    imports = [
        ../defaultHome.nix
    ];

    hyprconfig.enable = true;

    home = {
        username = "maksi";
        homeDirectory = "/home/maksi";

        stateVersion = "24.05";
        packages = with pkgs; [
            slack
            (discord.override {
                 withVencord = true;
            })
            btop

            gnome-control-center
            vlc
            pamixer

            yazi

            thunderbird #email

            spotube
            spotify

            onlyoffice-bin
            todo

            obs-studio
            teams-for-linux
            zoom-us
            ];
    };
}
