{ lib, config, pkgs, ... }:

{
    options = {
        gaming.enable 
            = lib.mkEnableOption "enable gaming";

    };

    config = lib.mkIf config.gaming.enable {
        programs = {
            steam = {
                enable = true;
                gamescopeSession.enable = true;
            };

            gamemode.enable = true;
        };

        environment.systemPackages = with pkgs; [
            protonup
            lutris
            heroic

            prismlauncher
            atlauncher
            portablemc
            hmcl
        ];

        environment.sessionVariables = {
            STEAM_EXTRA_COMPAT_TOOLS_PATHS =
                "\${HOME}/.steam/root/compatibilitytools.d";
        };
    };
}
