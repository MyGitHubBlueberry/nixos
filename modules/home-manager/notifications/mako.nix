{ pkgs, config, lib, ... }:

{
    options = {
        mako.enable
            = lib.mkEnableOption "enable mako";
    };

    config = lib.mkIf config.mako.enable {
        services.mako = {
            enable = true;

            anchor = "top-center";

            maxVisible = 3;
            
            defaultTimeout = 10000;

            # backgroundColor = "#${base00}";
            # borderColor = "#${base0E}";
            # textColor = "#${base0F}";

            borderRadius = 5;
            borderSize = 2;

            layer = "overlay";
        };
    };
}
