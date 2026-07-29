{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        teams-for-linux
        thunderbird #email

        onlyoffice-desktopeditors
        todo

        obs-studio
        zoom-us
    ];

    hyprconfig.enable = true;
    caelestia.enable = true;
    wallust.enable = true;
    programming.enable = true;
    wmApps.enable = true;
}
