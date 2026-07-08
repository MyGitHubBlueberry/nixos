{ lib, config, ... }:

{
    options = {
        kitty.enable 
            = lib.mkEnableOption "enable kitty";
    };

    config = lib.mkIf config.kitty.enable {
        programs.kitty = {
            enable = true;

            font = {
                name = "monospace";
                size = 23;
            };

            settings = {
                bold_font = "auto";
                italic_font = "auto";
                bold_italic_font = "auto";

                background_opacity = "0.8";
                background_blur = 10;
                enable_audio_bell = "no";
            };
            extraConfig = lib.optionalString (!config.caelestia.enable) ''
                include ~/.cache/wallust/colors-kitty.conf
            '';        
        };
        home.sessionVariables.TERMINAL = lib.mkDefault "kitty";

        xdg.terminal-exec = {
            enable = true;
            settings.default = [ "kitty.desktop" ];
        };
    };
}
