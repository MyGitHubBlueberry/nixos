{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop";
  services.tlp.enable = true;
  nvidia.enable = false;
  programming.enable = true;
  gaming.enable = false;
  virtualization.enable = false;
  windowManager = {
  	enable = true;
	hyprland.enable = true;
  };
  displayManager.sddm.enable = true;
  environment.systemPackages = with pkgs; [ ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  system.stateVersion = "24.05";
}
