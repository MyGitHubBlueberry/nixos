{ config, pkgs, ... }:
{
    home = {
        username = "maksi";
        homeDirectory = "/home/maksi";

        stateVersion = "24.05";
        packages = with pkgs; [
            slack
            (discord.override {
                 withVencord = true;
            })

            vlc

            thunderbird #email

            spotube
            spotify

            onlyoffice-desktopeditors
            todo

            obs-studio
            teams-for-linux
            zoom-us

            jetbrains.rider
            avalonia
            ];
    };
    hyprconfig.enable = true;
    caelestia.enable = true;
    wallust.enable = true;
}
