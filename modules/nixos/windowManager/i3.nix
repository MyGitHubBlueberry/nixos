{ lib, config, pkgs, ... }:

let
  cfg = config.windowManager;
in
{
    options.windowManager.i3.enable = lib.mkEnableOption "enable i3";

    config = lib.mkIf (cfg.enable && cfg.i3.enable) {
        assertions = [{
            assertion = !(cfg.hyprland.enable && cfg.i3.enable);
            message = "i3 and hyprland can't be enabled at the same time";
        }];
        services.xserver.windowManager.i3.enable = true;

        environment.systemPackages = with pkgs; [
            xss-lock
            i3lock-fancy-rapid
            xkb-switch-i3

            feh #wallpper
            picom #blur and other window stuff
            dunst #notifications
            libnotify #dunst dependency
            #screenshots
            maim 
            xclip
            wmctrl #used inscript for notifications
        ];

        programs.xss-lock = {
            enable = true;
            lockerCommand = "i3lock 5 3 --transfer-sleep-lock";
        };
    };
}
