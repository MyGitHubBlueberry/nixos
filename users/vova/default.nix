{ config, pkgs, ... }:

{
    home = {
        username = "vova";
        homeDirectory = "/home/vova";
        stateVersion = "25.05";
    };
    home.packages = with pkgs; [
    ];
}
