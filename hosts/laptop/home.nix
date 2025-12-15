{ config, pkgs, lib, ... }:

{
    home = {
        username = "maksi";
        homeDirectory = "/home/maksi";
        stateVersion = "25.05"; 
        packages = with pkgs; [
            teams-for-linux
            (discord.override {
             withVencord = true;
             })
            onlyoffice-bin
            slack
        ];
    };
    services.mpris-proxy.enable = true;
}
