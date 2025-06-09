{ lib, config, pkgs, ... }:

{
  options = {
    displayManager = {
      gdm.enable = lib.mkEnableOption "Enable GDM" // {
        default = false;
      };

      sddm.enable = lib.mkEnableOption "Enable SDDM" // {
        default = false;
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !(config.displayManager.gdm.enable && config.displayManager.sddm.enable);
        message = "Only one display manager can be enabled: either GDM or SDDM.";
      }
      {
        assertion = config.displayManager.gdm.enable || config.displayManager.sddm.enable;
        message = "Please, choose a display manager: either GDM or SDDM.";
      }
    ];

    services.xserver.displayManager.gdm = lib.mkIf config.displayManager.gdm.enable {
      enable = true;
      wayland = true; # todo
      banner = "NixOS, btw...";
      autoSuspend = true;
    };

    services.displayManager.sddm = lib.mkIf config.displayManager.sddm.enable {
      enable = true;
      wayland.enable = false;
      theme = "${import ../../packages/sddm-sugar-dark/default.nix { inherit pkgs; }}";
      extraPackages = with pkgs; [
          libsForQt5.qt5.qtquickcontrols2   
          libsForQt5.qt5.qtgraphicaleffects
      ];
    };
  };
}

