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
            xkb-switch-i3
            i3lock-fancy-rapid

            feh #wallpper
            picom #blur and other window stuff
            dunst #notifications
            libnotify #dunst dependency
            #screenshots
            maim 
            xclip
            wmctrl #used inscript for notifications
        ];
#todo: check about screen saver and dpms differences
        environment.extraInit = ''
            xset on
            xset s 120
            xset dpms 180 180 180
            '';
        programs.i3lock = {
            enable = true;
            package = pkgs.i3lock-fancy-rapid;
        };
        programs.xss-lock = {
            enable = true;
            lockerCommand = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 3 5";
        };
    };
}
