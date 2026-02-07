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

            onlyoffice-bin
            todo

            obs-studio
            teams-for-linux
            zoom-us
            ];
    };
    hyprconfig.enable = true;
}
