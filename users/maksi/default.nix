{ config, pkgs, ... }:

{
    home = {
        username = "maksi";
        homeDirectory = "/home/maksi";
        stateVersion = "24.05";
    };

    programs.git = {
        settings.user.name = "MyGitHubBlueberry";
        settings.user.email = "MyGitHubBlueberry@gmail.com";
    };

    home.packages = with pkgs; [
        teams-for-linux
        (discord.override {
             withVencord = true;
        })
        onlyoffice-desktopeditors
        slack
        jetbrains.rider
        vlc
    ];

    hyprconfig.enable = true;
    programming.enable = true;
    wmApps.enable = true;
}
