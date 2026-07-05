{ lib, config, pkgs, ... }:
{
    options = {
        caelestia.enable
            = lib.mkEnableOption "enable cealestia shell";
        caelestia.isLaptop = lib.mkEnableOption "laptop specific features like battery";
    };
    config = lib.mkIf config.caelestia.enable {
        home.packages = [ 
            pkgs.libnotify 
        ];
        programs.caelestia = {
            enable = true;
            systemd = {
                enable = true; # 'false' to start from compositor
                target = "graphical-session.target";
            };
            cli = {
                enable = true;
                settings = {
                    theme.enableGtk = false;
                };
            };
        };
    };
}
