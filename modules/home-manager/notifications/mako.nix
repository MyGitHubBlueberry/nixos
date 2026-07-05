{ pkgs, config, lib, ... }:

{
    options = {
        mako.enable
            = lib.mkEnableOption "enable mako";
    };

    config = lib.mkIf config.mako.enable {
        home.packages = [ 
            pkgs.libnotify 
        ];
        services.mako = {
            enable = true;

            anchor = "top-center";

            maxVisible = 3;
            
            defaultTimeout = 10000;

            borderRadius = 5;
            borderSize = 2;

            layer = "overlay";
        };
    };
}
