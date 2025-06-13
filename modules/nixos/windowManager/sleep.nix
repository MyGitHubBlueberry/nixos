{ lib, config, pkgs, ... }:

let
  cfg = config.windowManager;
in
{
  config = lib.mkIf cfg.enable {
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
