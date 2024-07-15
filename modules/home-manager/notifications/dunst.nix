{ pkgs, config, lib, ... }:

{
    options = {
        dunst.enable
            = lib.mkEnableOption "enable dunst";
    };

    config = lib.mkIf config.dunst.enable {
        services.dunst = {
            enable = true;

            settings = {
                global = {
                    width = 300;
                    height = 300;
                    offset = "30x50";
                    origin = "top-center";
                    transparency = 10;
                    frame_color = "#eceff1";
                    font = "Droid Sans 9";
                };

                urgency_normal = {
                    background = "#37474f";
                    foreground = "#eceff1";
                    timeout = 10;
                };
            };
        };
    };
}
