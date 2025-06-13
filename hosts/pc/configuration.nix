{ config, pkgs, inputs, ... }:

{
    imports = [ 
    ./hardware-configuration.nix 
    ];
    networking.hostName = "pc";

    nvidia.enable = true;
    programming.enable = true;
    gaming.enable = true;
    virtualization.enable = true;
    windowManager = {
        enable = true;
        i3.enable = true;
        hyprland.enable = false;
    };
    displayManager.gdm.enable = true;

    boot.resumeDevice = "/dev/disk/by-uuid/de1eff34-10fc-4229-b149-782ff0b66291";

    environment.systemPackages = with pkgs; [];

    system.stateVersion = "23.11"; #Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
}
