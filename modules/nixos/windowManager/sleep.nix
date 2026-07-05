{ lib, config, ... }:

let
    cfg = config.windowManager;
in
{
    config = lib.mkIf cfg.enable {
        systemd.sleep.settings.Sleep = {
            HibernateDelaySec="15min";
        };
        services.logind.settings.Login = 
        {
            IdleAction = (if config.nvidia.enable then [
                "suspend"
            ] else [
                "suspend-then-hibernate"
            ]);
            IdleActionSec="10min";
        };

        services.logind = {
            powerKey = "suspend-then-hibernate";
            lidSwitch = "suspend-then-hibernate";
        };
    };
}
