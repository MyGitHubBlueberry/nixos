{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ];

#temporary
    services.postgresql = {
        enable = true;
        authentication = pkgs.lib.mkOverride 10 ''
#type database  DBuser  auth-method
            local all       all     trust
            '';
    };

    networking.hostName = "laptop";
    services.tlp.enable = true;
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
