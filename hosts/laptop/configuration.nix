# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "laptop"; # Define your hostname.

  nvidia.enable = false;
  programming.enable = true;
  gaming.enable = false;
  virtualization.enable = false;
  windowManager = {
  	enable = true;
	hyprland.enable = true;
  };
  displayManager.gdm.enable = true;
  environment.systemPackages = with pkgs; [ ];

  system.stateVersion = "24.05";

}
