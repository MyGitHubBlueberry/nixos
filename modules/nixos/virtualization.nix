{ lib, config, pkgs, ... }:

{
    options = {
        virtualization.enable 
            = lib.mkEnableOption "enable virtualization";

    };

    config = lib.mkIf config.virtualization.enable {
          virtualisation.virtualbox = {
              host = {
                  enable = true; 
                  enableExtensionPack = true;
              };
              guest = {
                  enable = true;
                  draganddrop = true;
              };
          };

          users.extraGroups.vboxusers.members = [ "maksi" ];
    };
}
