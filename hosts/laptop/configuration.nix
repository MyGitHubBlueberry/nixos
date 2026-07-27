{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

    networking.hostName = "laptop";
    services.tlp.enable = true;
    autorandr.laptopDocStation.enable = true;
    laptopLid.enable = false;
    nvidia.enable = false;
    programming.enable = true;
    gaming.enable = true;
    virtualization.enable = false;
    windowManager = {
        enable = true;
        i3.enable = true;
    };
    displayManager.gdm.enable = true;

    environment.systemPackages = with pkgs; [ ];

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    system.stateVersion = "24.05";
}
