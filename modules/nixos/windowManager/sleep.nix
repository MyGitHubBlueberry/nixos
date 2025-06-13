{ lib, config, pkgs, ... }:

let
  cfg = config.windowManager;
in
{
  options.windowManager.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf con.enable {
    systemd.sleep.extraConfig = '' 
        HibernateDelaySec=10min
        '';
    services.logind.extraConfig = builtins.concatStringsSep "\n"(
        (if config.nvidia.enable then [
            "IdleAction=suspend"
        ] else [
            "IdleAction=suspend-then-hibernate"
        ]) ++ [
            "IdleActionSec=5min"
        ]);
    };
}
