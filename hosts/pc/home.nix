{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
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

    hyprconfig.enable = true;
    caelestia.enable = true;
    wallust.enable = true;
    programming.enable = true;
    wmApps.enable = true;
}
