{ lib, config, ... }:

let
cfg = config.windowManager;
in
{
    config = lib.mkIf cfg.enable {
        systemd.sleep.extraConfig = '' 
            HibernateDelaySec=15min
            '';
        services.logind.extraConfig = builtins.concatStringsSep "\n"(
            (if config.nvidia.enable then [
             "IdleAction=suspend"
            ] else [
            "IdleAction=suspend-then-hibernate"
            ]) ++ [
            "IdleActionSec=10min"
            ]);

        services.logind = {
            powerKey = "suspend-then-hibernate";
            lidSwitch = "suspend-then-hibernate";
        };

    };
}
