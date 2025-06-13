{ config, pkgs, lib, ... }:

{
    home = {
        username = "maksi";
        homeDirectory = "/home/maksi";
        stateVersion = "25.05"; 

        services.mpris-proxy.enable = true;

        packages = [
        ];
    };
}
